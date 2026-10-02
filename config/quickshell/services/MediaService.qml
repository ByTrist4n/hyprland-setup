import "../theme"
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
pragma Singleton

Item {
    id: root

    // Active player selection logic
    property MprisPlayer selectedPlayer: null
    readonly property var availablePlayers: Mpris.players.values
    readonly property MprisPlayer activePlayer: {
        if (root.selectedPlayer && root.availablePlayers.includes(root.selectedPlayer))
            return root.selectedPlayer;

        if (root.availablePlayers.length === 0)
            return null;

        const playing = root.availablePlayers.find((p) => {
            return p.playbackState === MprisPlaybackState.Playing;
        });
        return playing || root.availablePlayers[0];
    }
    // Exposed raw media metadata
    readonly property string rawTrackTitle: activePlayer ? (activePlayer.trackTitle || "").trim() : ""
    readonly property string rawTrackArtist: activePlayer ? (activePlayer.trackArtist || "").trim() : ""
    readonly property string trackArtUrl: activePlayer ? (activePlayer.trackArtUrl || "") : ""
    readonly property bool rawIsPlaying: activePlayer ? (activePlayer.playbackState === MprisPlaybackState.Playing) : false
    // Track length calculation (checking length property or metadata fallback)
    readonly property real length: {
        if (!activePlayer)
            return 0;

        // Check native property or metadata
        const rawLen = activePlayer.length || (activePlayer.metadata ? activePlayer.metadata["mpris:length"] : 0);
        if (!rawLen)
            return 0;

        const numLen = Number(rawLen);
        // If greater than 100 000, it's in microseconds, convert to seconds
        return numLen > 100000 ? (numLen / 1e+06) : numLen;
    }
    // Local position tracking
    property real position: 0
    readonly property real progress: length > 0 ? Math.min(1, position / length) : 0
    // Buffered properties
    property string trackTitle: ""
    property string trackArtist: ""
    property bool hasMedia: false
    property bool isPlaying: false

    // Fetch exact position from MPRIS player
    function syncPosition() {
        if (!activePlayer) {
            position = 0;
            return ;
        }
        // Fetch position from player
        let pos = 0;
        if (typeof activePlayer.position === "number")
            pos = activePlayer.position;
        else if (typeof activePlayer.position === "function")
            pos = activePlayer.position();
        else if (activePlayer.position !== undefined)
            pos = Number(activePlayer.position);
        // Convert microseconds to seconds if needed
        if (pos > 100000)
            pos = pos / 1e+06;

        position = pos;
    }

    // Helper to format seconds into mm:ss or hh:mm:ss
    function formatTime(seconds) {
        if (!seconds || seconds <= 0 || isNaN(seconds))
            return "0:00";

        const totalSeconds = Math.floor(seconds);
        const hrs = Math.floor(totalSeconds / 3600);
        const mins = Math.floor((totalSeconds % 3600) / 60);
        const secs = totalSeconds % 60;
        const formattedSecs = secs < 10 ? "0" + secs : secs;
        if (hrs > 0) {
            const formattedMins = mins < 10 ? "0" + mins : mins;
            return hrs + ":" + formattedMins + ":" + formattedSecs;
        }
        return mins + ":" + formattedSecs;
    }

    function focusPlayerWindow() {
        if (!activePlayer)
            return ;

        if (activePlayer.canRaise)
            activePlayer.raise();

        Hyprland.refreshToplevels();
        const toplevels = Hyprland.toplevels ? Hyprland.toplevels.values : [];
        const entry = (activePlayer.desktopEntry || "").toLowerCase();
        const identity = (activePlayer.identity || "").toLowerCase();
        const title = root.trackTitle.toLowerCase();
        const classMatches = (t) => {
            const c = ((t.lastIpcObject && t.lastIpcObject.class) || "").toLowerCase();
            return (entry && c.includes(entry)) || (identity && c.includes(identity));
        };
        const match = toplevels.find((t) => {
            return classMatches(t) && title && (t.title || "").toLowerCase().includes(title);
        }) || toplevels.find(classMatches);
        if (match)
            Hyprland.dispatch(`hl.dsp.focus({ window = "address:${match.lastIpcObject.address}" })`);

    }

    // Sync state and position on change
    function syncState() {
        if (rawIsPlaying)
            isPlaying = true;

        if (rawTrackTitle !== "") {
            trackTitle = rawTrackTitle;
            trackArtist = rawTrackArtist;
            hasMedia = true;
        }
        syncPosition();
        debounceTimer.restart();
    }

    // Player selection controls
    function selectPlayer(player) {
        root.selectedPlayer = player;
        syncState();
    }

    function resetAutoSelect() {
        root.selectedPlayer = null;
        syncState();
    }

    // Playback control wrappers
    function previous() {
        if (activePlayer && activePlayer.canGoPrevious)
            activePlayer.previous();

    }

    function togglePlaying() {
        if (activePlayer && activePlayer.canTogglePlaying)
            activePlayer.togglePlaying();

    }

    function next() {
        if (activePlayer && activePlayer.canGoNext)
            activePlayer.next();

    }

    // Icon resolver based on desktop entry or player identity
    function playerIcon(player) {
        if (!player)
            return ThemeIcons.music;

        const id = (player.identity || "").toLowerCase();
        if (id.includes("spotify"))
            return ThemeIcons.spotify;

        if (id.includes("firefox") || id.includes("zen"))
            return ThemeIcons.firefox;

        if (id.includes("chromium") || id.includes("chrome"))
            return ThemeIcons.chrome;

        if (id.includes("vlc"))
            return ThemeIcons.media;

        if (id.includes("youtube-music") || id.includes("ytmusic"))
            return ThemeIcons.youtube;

        return ThemeIcons.music;
    }

    // Pause all other active players when a new one starts playing
    function enforceSinglePlayback(current) {
        availablePlayers.forEach((p) => {
            if (p !== current && p.playbackState === MprisPlaybackState.Playing && p.canPause)
                p.pause();

        });
    }

    onRawTrackTitleChanged: syncState()
    onRawTrackArtistChanged: syncState()
    onActivePlayerChanged: syncState()
    onRawIsPlayingChanged: syncState()

    // Timer to update position every second
    Timer {
        id: positionTimer

        interval: 1000
        running: root.isPlaying && root.activePlayer != null
        repeat: true
        onTriggered: {
            // Either resync from MPRIS or increment manually if playback is smooth
            if (root.length > 0 && root.position < root.length)
                root.position += 1;
            else
                root.syncPosition();
        }
    }

    // Debounce timer
    Timer {
        id: debounceTimer

        interval: 350
        onTriggered: {
            if (!root.rawIsPlaying)
                root.isPlaying = false;

            if (root.rawTrackTitle === "") {
                root.trackTitle = "";
                root.trackArtist = "";
                root.hasMedia = false;
            }
        }
    }

    // Watch players
    Instantiator {
        model: Mpris.players.values

        delegate: Item {
            required property MprisPlayer modelData

            Connections {
                function onPlaybackStateChanged() {
                    if (modelData.playbackState === MprisPlaybackState.Playing) {
                        root.selectedPlayer = modelData;
                        root.enforceSinglePlayback(modelData);
                    }
                }

                target: modelData
            }

        }

    }

}
