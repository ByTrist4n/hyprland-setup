import "../../services"
import "../../theme"
import "../ui"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Wayland

UiPopup {
    minWidth: 320

    RowLayout {
        id: musicRow

        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 12

        Rectangle {
            Layout.preferredWidth: 76
            Layout.preferredHeight: 76
            radius: 8
            color: ThemeColors.bgSurfaceActive

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: MediaService ? MediaService.trackArtUrl : ""
                visible: null != MediaService
                layer.enabled: true

                layer.effect: OpacityMask {

                    maskSource: Rectangle {
                        width: 76
                        height: 76
                        radius: 8
                    }

                }

            }

            Text {
                anchors.centerIn: parent
                text: ThemeIcons.music
                font.pixelSize: ThemeFonts.lg
                color: ThemeColors.fgPrimary
                visible: null == MediaService
            }

        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                Layout.fillWidth: true
                text: MediaService && MediaService.trackTitle ? MediaService.trackTitle : "No media playing"
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.sm
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: MediaService && MediaService.trackArtist ? MediaService.trackArtist : "Unknown artist"
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.xs
                elide: Text.ElideRight
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                visible: MediaService ? MediaService.availablePlayers.length > 1 : false

                Repeater {
                    model: MediaService ? MediaService.availablePlayers : []

                    delegate: Rectangle {
                        required property MprisPlayer modelData

                        width: 24
                        height: 24
                        radius: 4
                        color: MediaService.activePlayer === modelData ? ThemeColors.bgSurfaceActive : "transparent"
                        border.color: MediaService.activePlayer === modelData ? ThemeColors.borderBase : "transparent"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: MediaService.playerIcon(modelData)
                            font.pixelSize: ThemeFonts.xs
                            color: ThemeColors.fgPrimary
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: MediaService.selectPlayer(modelData)
                        }

                    }

                }

            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                UiButton {
                    Layout.fillWidth: true
                    enabled: null != MediaService
                    onClicked: MediaService.previous()
                    contentText: ThemeIcons.skipPrevious
                }

                UiButton {
                    Layout.fillWidth: true
                    enabled: null != MediaService
                    onClicked: MediaService.togglePlaying()
                    contentText: (MediaService && MediaService.isPlaying) ? ThemeIcons.pause : ThemeIcons.play
                }

                UiButton {
                    Layout.fillWidth: true
                    enabled: null != MediaService
                    onClicked: MediaService.next()
                    contentText: ThemeIcons.skipNext
                }

            }

        }

    }

}
