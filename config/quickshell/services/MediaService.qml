import QtQuick
import Quickshell
import Quickshell.Services.Mpris
pragma Singleton

Item {
    id: root

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
    property string trackTitle: "No media playing"
    property string trackArtist: "Unknown artist"
    property bool isPlaying: false
    readonly property string trackArtUrl: activePlayer ? activePlayer.trackArtUrl : ""

    function selectPlayer(player) {
        root.selectedPlayer = player;
    }

    function resetAutoSelect() {
        root.selectedPlayer = null;
    }

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

    function playerIcon(player) {
        if (!player)
            return ThemeIcon.music;

        const id = player.identity ? player.identity.toLowerCase() : "";
        if (id.includes("spotify"))
            return "󰓇";

        if (id.includes("firefox") || id.includes("zen"))
            return "󰈹";

        if (id.includes("chromium") || id.includes("chrome"))
            return "󰊯";

        if (id.includes("vlc"))
            return "󰕼";

        if (id.includes("youtube-music"))
            return "󰗃";

        return ThemeIcon.music;
    }

    function enforceSinglePlayback(current) {
        availablePlayers.forEach((p) => {
            if (p !== current && p.playbackState === MprisPlaybackState.Playing && p.canPause)
                p.pause();

        });
    }

    function syncTrackInfo() {
        const title = activePlayer ? activePlayer.trackTitle : "";
        const artist = activePlayer ? activePlayer.trackArtist : "";
        if (title && title.trim() !== "") {
            resetTimer.stop();
            trackTitle = title;
            trackArtist = (artist && artist.trim() !== "") ? artist : "Unknown artist";
            isPlaying = activePlayer ? activePlayer.isPlaying : false;
        } else if (!resetTimer.running) {
            resetTimer.start();
        }
    }

    onActivePlayerChanged: syncTrackInfo()

    Timer {
        id: resetTimer

        interval: 350
        onTriggered: {
            root.trackTitle = "No media playing";
            root.trackArtist = "Unknown artist";
            root.isPlaying = false;
        }
    }

    Timer {
        id: pauseDebounceTimer

        interval: 300
        onTriggered: root.isPlaying = root.activePlayer ? root.activePlayer.isPlaying : false
    }

    Connections {
        function onTrackTitleChanged() {
            root.syncTrackInfo();
        }

        function onTrackArtistChanged() {
            root.syncTrackInfo();
        }

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
