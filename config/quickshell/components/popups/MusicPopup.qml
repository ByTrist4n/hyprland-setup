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
            color: ThemeColor.bgSurfaceActive

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
                text: ""
                font.pixelSize: ThemeFont.lg
                color: ThemeColor.fgPrimary
                visible: null == MediaService
            }

        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                Layout.fillWidth: true
                text: MediaService && MediaService.trackTitle ? MediaService.trackTitle : "No media playing"
                color: ThemeColor.fgPrimary
                font.pixelSize: ThemeFont.sm
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: MediaService && MediaService.trackArtist ? MediaService.trackArtist : "Unknown artist"
                color: ThemeColor.fgPrimary
                font.pixelSize: ThemeFont.xs
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
                        color: MediaService.activePlayer === modelData ? ThemeColor.bgSurfaceActive : "transparent"
                        border.color: MediaService.activePlayer === modelData ? ThemeColor.borderBase : "transparent"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: MediaService.playerIcon(modelData)
                            font.pixelSize: ThemeFont.xs
                            color: ThemeColor.fgPrimary
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
                    textButton: "󰼨"
                }

                UiButton {
                    Layout.fillWidth: true
                    enabled: null != MediaService
                    onClicked: MediaService.togglePlaying()
                    textButton: (MediaService && MediaService.isPlaying) ? "󰏤" : "󰐊"
                }

                UiButton {
                    Layout.fillWidth: true
                    enabled: null != MediaService
                    onClicked: MediaService.next()
                    textButton: "󰼧"
                }

            }

        }

    }

}
