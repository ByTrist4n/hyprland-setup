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
            UiText {
                text: "Audio Controls"
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.lg
                font.bold: true
                Layout.fillWidth: true
            }

            UiButton {
                text: ThemeIcons.cross
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

                UiText {
                    text: "Volume"
                    color: ThemeColors.fgMuted
                    font.pixelSize: ThemeFonts.sm
                    font.bold: true
                    Layout.fillWidth: true
                }

                UiText {
                    text: AudioService.muted ? "Mute" : Math.round(AudioService.volume * 100) + "%"
                    color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.fgPrimary
                    font.pixelSize: ThemeFonts.md
                    font.bold: true
                }

                UiButton {
                    text: AudioService.muted ? ThemeIcons.volumeOff : ThemeIcons.volume
                    fgColor: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                    font.pixelSize: ThemeFonts.lg

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: AudioService.toggleMute()
                    }

                }

            }

            UiSlider {
                value: AudioService.volume
                enabled: !AudioService.muted
                onValueChangedRequested: (newValue) => {
                    return AudioService.setVolume(newValue);
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

                UiText {
                    text: "Microphone"
                    color: ThemeColors.fgMuted
                    font.pixelSize: ThemeFonts.sm
                    font.bold: true
                    Layout.fillWidth: true
                }

                UiText {
                    text: AudioService.micMuted ? "Mute" : Math.round(AudioService.micVolume * 100) + "%"
                    color: AudioService.micMuted ? ThemeColors.fgMuted : ThemeColors.fgPrimary
                    font.pixelSize: ThemeFonts.md
                    font.bold: true
                }

                UiButton {
                    text: AudioService.micMuted ? ThemeIcons.micOff : ThemeIcons.mic
                    fgColor: AudioService.micMuted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
                    font.pixelSize: ThemeFonts.lg

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: AudioService.toggleMicMute()
                    }

                }

            }

            UiSlider {
                value: AudioService.micVolume
                enabled: !AudioService.micMuted
                onValueChangedRequested: (newValue) => {
                    return AudioService.setMicVolume(newValue);
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
            text: ThemeIcons.volume + " Audio settings"
            hasBorder: true
            pixelSize: ThemeFonts.sm
            onClicked: {
                Hyprland.dispatch("hl.dsp.exec_cmd(\"pavucontrol\")");
                root.toggle();
            }
        }

    }

}
