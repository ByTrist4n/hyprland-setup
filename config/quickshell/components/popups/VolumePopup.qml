import "../../services"
import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

UiPopup {
    id: root

    minWidth: 300

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 16

        RowLayout {
            Text {
                text: "Audio Controls"
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.lg
                font.bold: true
                Layout.fillWidth: true
            }

            UiButton {
                contentText: ThemeIcons.cross
                onClicked: {
                    root.toggle();
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
                    color: ThemeColors.fgMuted
                    font.pixelSize: ThemeFonts.sm
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: AudioService.muted ? "Mute" : Math.round(AudioService.volume * 100) + "%"
                    color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.fgPrimary
                    font.pixelSize: ThemeFonts.md
                    font.bold: true
                }

                Text {
                    text: AudioService.muted ? ThemeIcons.volumeOff : ThemeIcons.volume
                    color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                    font.pixelSize: ThemeFonts.lg

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
                    color: ThemeColors.bgSurface
                }

                Rectangle {
                    anchors.left: track.left
                    anchors.verticalCenter: track.verticalCenter
                    width: track.width * AudioService.volume
                    height: track.height
                    radius: height / 2
                    color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    anchors.verticalCenter: track.verticalCenter
                    x: Math.max(0, Math.min(slider.width - width, AudioService.volume * slider.width - width / 2))
                    color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                    border.width: 2
                    border.color: ThemeColors.bgBase
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
            color: ThemeColors.borderBase
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
                    color: ThemeColors.fgMuted
                    font.pixelSize: ThemeFonts.sm
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: AudioService.micMuted ? "Mute" : Math.round(AudioService.micVolume * 100) + "%"
                    color: AudioService.micMuted ? ThemeColors.fgMuted : ThemeColors.fgPrimary
                    font.pixelSize: ThemeFonts.md
                    font.bold: true
                }

                Text {
                    text: AudioService.micMuted ? ThemeIcons.micOff : ThemeIcons.mic
                    color: AudioService.micMuted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                    font.pixelSize: ThemeFonts.lg

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
                    color: ThemeColors.bgSurface
                }

                Rectangle {
                    anchors.left: micTrack.left
                    anchors.verticalCenter: micTrack.verticalCenter
                    width: micTrack.width * AudioService.micVolume
                    height: micTrack.height
                    radius: height / 2
                    color: AudioService.micMuted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    anchors.verticalCenter: micTrack.verticalCenter
                    x: Math.max(0, Math.min(micSlider.width - width, AudioService.micVolume * micSlider.width - width / 2))
                    color: AudioService.micMuted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                    border.width: 2
                    border.color: ThemeColors.bgBase
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
            color: ThemeColors.borderBase
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        UiButton {
            Layout.fillWidth: true
            contentText: ThemeIcons.volume + " Audio settings"
            hasBorder: true
            pixelSize: ThemeFonts.sm
            onClicked: {
                Hyprland.dispatch("hl.dsp.exec_cmd(\"pavucontrol\")");
                root.toggle();
            }
        }

    }

}
