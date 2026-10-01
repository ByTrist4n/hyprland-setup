import QtQuick
import Quickshell
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
    // Buffered properties to prevent UI flickering during track changes
    property string trackTitle: ""
    property string trackArtist: ""
    property bool hasMedia: false
    property bool isPlaying: false

    // Sync metadata with debounced visibility logic
    function syncState() {
        // Immediate updates when media starts playing or new metadata arrives
        if (rawIsPlaying)
            isPlaying = true;

        if (rawTrackTitle !== "") {
            trackTitle = rawTrackTitle;
            trackArtist = rawTrackArtist;
            hasMedia = true;
        }
        // Restart debounce timer to handle delayed clear/pause states
        debounceTimer.restart();
    }

    // Player selection controls
    function selectPlayer(player) {
        root.selectedPlayer = player;
    }

    function resetAutoSelect() {
        root.selectedPlayer = null;
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
            return "󰓇";

        if (id.includes("firefox") || id.includes("zen"))
            return "󰈹";

        if (id.includes("chromium") || id.includes("chrome"))
            return "󰊯";

        if (id.includes("vlc"))
            return "󰕼";

        if (id.includes("youtube-music") || id.includes("ytmusic"))
            return "󰗃";

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

    // Timer to delay hiding the widget when isPlaying/trackTitle temporarily drops to empty
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

    // Watch all players to auto-switch active player on playback
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
