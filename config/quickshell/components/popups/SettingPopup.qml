import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

UiPopup {
    id: root

    minWidth: 320

    ColumnLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 16

        // Popup header with title and close button
        RowLayout {
            Layout.fillWidth: true

            UiText {
                text: "System Controls"
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

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeColors.borderBase
        }

        // Section title for screen captures
        UiText {
            text: "Screen Capture"
            color: ThemeColors.accentPrimary
            font.pixelSize: ThemeFonts.sm
            font.bold: true
        }

        // Card 1 - Video Recording
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 48
            radius: 8
            color: recMouse.containsMouse ? ThemeColors.bgSurfaceActive : ThemeColors.bgSurface
            border.color: ThemeColors.borderBase
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                UiText {
                    text: ThemeIcons.video
                    color: ThemeColors.urgent
                    font.pixelSize: ThemeFonts.lg
                }

                UiText {
                    text: "Record Screen"
                    color: ThemeColors.fgPrimary
                    font.pixelSize: ThemeFonts.sm
                    Layout.fillWidth: true
                }

            }

            MouseArea {
                id: recMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.toggle();
                    Hyprland.dispatch("hl.dsp.exec_cmd(\"sh ~/.config/hyprland-setup/scripts/video-capture.sh\")");
                }
            }

        }

        // Card 2 - Screenshot
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 48
            radius: 8
            color: shotMouse.containsMouse ? ThemeColors.bgSurfaceActive : ThemeColors.bgSurface
            border.color: ThemeColors.borderBase
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 12

                UiText {
                    text: ThemeIcons.monitorScreen
                    color: ThemeColors.accentPrimary
                    font.pixelSize: ThemeFonts.lg
                }

                UiText {
                    text: "Take Screenshot"
                    color: ThemeColors.fgPrimary
                    font.pixelSize: ThemeFonts.sm
                    Layout.fillWidth: true
                }

            }

            MouseArea {
                id: shotMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.toggle();
                    Hyprland.dispatch("hl.dsp.exec_cmd(\"sh ~/.config/hyprland-setup/scripts/screenshot.sh save\")");
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

        // Card 3 - Session Power Menu
        UiButton {
            Layout.fillWidth: true
            contentText: ThemeIcons.power + " Power Menu"
            hasBorder: true
            pixelSize: ThemeFonts.sm
            onClicked: {
                root.toggle();
                Hyprland.dispatch("hl.dsp.exec_cmd(\"wlogout\")");
            }
        }

    }

}
