import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Rectangle {
    id: root

    // Fetch the active MPRIS player or fallback to first available
    property MprisPlayer activePlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    implicitWidth: 320
    implicitHeight: 100
    color: "#1e1e2e"
    radius: 12
    border.color: "#313244"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Album Art Thumbnail
        Rectangle {
            Layout.preferredWidth: 76
            Layout.preferredHeight: 76
            radius: 8
            color: "#181825"
            clip: true

            Image {
                anchors.fill: parent
                source: root.activePlayer ? root.activePlayer.trackArtUrl : ""
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
            }

            // Fallback icon when no artwork is available
            Text {
                anchors.centerIn: parent
                text: "󰎈"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: ThemeFont.lg
                color: "#6c7086"
                visible: !root.activePlayer || !root.activePlayer.trackArtUrl
            }

        }

        // Track Details and Playback Controls
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            // Track Title
            Text {
                Layout.fillWidth: true
                text: root.activePlayer && root.activePlayer.trackTitle ? root.activePlayer.trackTitle : "No media playing"
                color: "#cdd6f4"
                font.pixelSize: ThemeFont.sm
                font.bold: true
                elide: Text.ElideRight
            }

            // Artist Name
            Text {
                Layout.fillWidth: true
                text: root.activePlayer && root.activePlayer.trackArtist ? root.activePlayer.trackArtist : "Unknown artist"
                color: "#a6adc8"
                font.pixelSize: ThemeFont.xs
                elide: Text.ElideRight
            }

            // Control Buttons
            RowLayout {
                spacing: 12

                // Previous Track
                Button {
                    flat: true
                    enabled: root.activePlayer ? root.activePlayer.canGoPrevious : false
                    onClicked: root.activePlayer.previous()

                    contentItem: Text {
                        text: "󰒮"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: ThemeFont.lg
                        color: parent.enabled ? "#cdd6f4" : "#45475a"
                    }

                }

                // Play / Pause Toggle
                Button {
                    flat: true
                    enabled: root.activePlayer ? root.activePlayer.canTogglePlaying : false
                    onClicked: root.activePlayer.togglePlaying()

                    contentItem: Text {
                        text: (root.activePlayer && root.activePlayer.isPlaying) ? "󰏤" : "󰐊"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: ThemeFont.lg
                        color: parent.enabled ? "#89b4fa" : "#45475a"
                    }

                }

                // Next Track
                Button {
                    flat: true
                    enabled: root.activePlayer ? root.activePlayer.canGoNext : false
                    onClicked: root.activePlayer.next()

                    contentItem: Text {
                        text: "󰒝"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: ThemeFont.lg
                        color: parent.enabled ? "#cdd6f4" : "#45475a"
                    }

                }

            }

        }

    }

}
