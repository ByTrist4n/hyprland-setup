import "../../services"
import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

UiPopup {
    minWidth: 300

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 16

        RowLayout {
            Text {
                text: "Audio Controls"
                color: ThemeColor.fgPrimary
                font.pixelSize: ThemeFont.lg
                font.bold: true
                Layout.fillWidth: true
            }

            Text {
                text: "󰅖"
                color: ThemeColor.fgMuted
                font.pixelSize: ThemeFont.md

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: isOpened = false
                }

            }

        }

        // ==================== AUDIO OUTPUT ====================
        ColumnLayout {
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Volume"
                    color: ThemeColor.fgMuted
                    font.pixelSize: ThemeFont.sm
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: AudioService.muted ? "Mute" : Math.round(AudioService.volume * 100) + "%"
                    color: AudioService.muted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
                    font.pixelSize: ThemeFont.md
                    font.bold: true
                }

                Text {
                    text: AudioService.muted ? "󰝟" : "󰕾"
                    color: AudioService.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    font.pixelSize: ThemeFont.lg

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: AudioService.toggleMute()
                    }

                }

            }

            Item {
                id: slider

                Layout.fillWidth: true
                implicitHeight: 24

                Rectangle {
                    id: track

                    x: 0
                    width: parent.width
                    height: 8
                    anchors.verticalCenter: parent.verticalCenter
                    radius: height / 2
                    color: ThemeColor.bgSurface
                }

                Rectangle {
                    anchors.left: track.left
                    anchors.verticalCenter: track.verticalCenter
                    width: track.width * AudioService.volume
                    height: track.height
                    radius: height / 2
                    color: AudioService.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    anchors.verticalCenter: track.verticalCenter
                    x: Math.max(0, Math.min(slider.width - width, AudioService.volume * slider.width - width / 2))
                    color: AudioService.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    border.width: 2
                    border.color: ThemeColor.bgBase
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    preventStealing: true
                    onPressed: (mouse) => {
                        return AudioService.setVolume(mouse.x / slider.width);
                    }
                    onPositionChanged: (mouse) => {
                        if (pressed)
                            AudioService.setVolume(mouse.x / slider.width);

                    }
                    onWheel: (wheel) => {
                        const step = 0.02;
                        AudioService.setVolume(AudioService.volume + (wheel.angleDelta.y > 0 ? step : -step));
                        wheel.accepted = true;
                    }
                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: ThemeColor.borderBase
            opacity: 0.5
        }

        // ==================== MICROPHONE ====================
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Microphone"
                    color: ThemeColor.fgMuted
                    font.pixelSize: ThemeFont.sm
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: AudioService.micMuted ? "Mute" : Math.round(AudioService.micVolume * 100) + "%"
                    color: AudioService.micMuted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
                    font.pixelSize: ThemeFont.md
                    font.bold: true
                }

                Text {
                    text: AudioService.micMuted ? "󰍭" : "󰍬"
                    color: AudioService.micMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    font.pixelSize: ThemeFont.lg

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: AudioService.toggleMicMute()
                    }

                }

            }

            Item {
                id: micSlider

                Layout.fillWidth: true
                implicitHeight: 24

                Rectangle {
                    id: micTrack

                    x: 0
                    width: parent.width
                    height: 8
                    anchors.verticalCenter: parent.verticalCenter
                    radius: height / 2
                    color: ThemeColor.bgSurface
                }

                Rectangle {
                    anchors.left: micTrack.left
                    anchors.verticalCenter: micTrack.verticalCenter
                    width: micTrack.width * AudioService.micVolume
                    height: micTrack.height
                    radius: height / 2
                    color: AudioService.micMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    anchors.verticalCenter: micTrack.verticalCenter
                    x: Math.max(0, Math.min(micSlider.width - width, AudioService.micVolume * micSlider.width - width / 2))
                    color: AudioService.micMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    border.width: 2
                    border.color: ThemeColor.bgBase
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    preventStealing: true
                    onPressed: (mouse) => {
                        return AudioService.setMicVolume(mouse.x / micSlider.width);
                    }
                    onPositionChanged: (mouse) => {
                        if (pressed)
                            AudioService.setMicVolume(mouse.x / micSlider.width);

                    }
                    onWheel: (wheel) => {
                        const step = 0.02;
                        AudioService.setMicVolume(AudioService.micVolume + (wheel.angleDelta.y > 0 ? step : -step));
                        wheel.accepted = true;
                    }
                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeColor.borderBase
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        UiButton {
            Layout.fillWidth: true
            contentText: " Audio settings"
            hasBorder: true
            pixelSize: ThemeFont.sm
            onClicked: {
                Hyprland.dispatch("hl.dsp.exec_cmd(\"pavucontrol\")");
                root.toggle();
            }
        }

    }

}
