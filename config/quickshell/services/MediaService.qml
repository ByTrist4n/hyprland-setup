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
    // Exposed media metadata
    readonly property string rawTrackTitle: activePlayer ? (activePlayer.trackTitle || "").trim() : ""
    readonly property string rawTrackArtist: activePlayer ? (activePlayer.trackArtist || "").trim() : ""
    readonly property string trackArtUrl: activePlayer ? (activePlayer.trackArtUrl || "") : ""
    // Buffered properties to prevent flickering during track changes
    property string trackTitle: ""
    property string trackArtist: ""
    property bool hasMedia: false
    property bool isPlaying: false

    // Sync metadata with debounced visibility logic
    function syncMetadata() {
        if (rawTrackTitle === "") {
            mediaDebounceTimer.start();
        } else {
            mediaDebounceTimer.stop();
            trackTitle = rawTrackTitle;
            trackArtist = rawTrackArtist;
            hasMedia = true;
        }
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

    onRawTrackTitleChanged: syncMetadata()
    onRawTrackArtistChanged: syncMetadata()
    onActivePlayerChanged: syncMetadata()

    // Timer to delay hiding the widget when trackTitle temporarily drops to empty
    Timer {
        id: mediaDebounceTimer

        interval: 350
        onTriggered: {
            root.trackTitle = "";
            root.trackArtist = "";
            root.hasMedia = false;
        }
    }

    // Debounce timer for play/pause toggle states
    Timer {
        id: pauseDebounceTimer

        interval: 300
        onTriggered: root.isPlaying = root.activePlayer ? root.activePlayer.isPlaying : false
    }

    // Listen to playing state changes on active player
    Connections {
        function onIsPlayingChanged() {
            if (root.activePlayer && root.activePlayer.isPlaying) {
                pauseDebounceTimer.stop();
                root.isPlaying = true;
            } else {
                pauseDebounceTimer.start();
            }
        }

        target: root.activePlayer
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
