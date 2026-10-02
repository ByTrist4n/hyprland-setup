import "../../services"
import "../../theme"
import "../ui"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

UiPopup {
    minWidth: 340

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            // Cover Art
            Rectangle {
                Layout.preferredWidth: 64
                Layout.preferredHeight: 64
                radius: 8
                color: ThemeColors.bgSurfaceActive

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: MediaService ? MediaService.trackArtUrl : ""
                    visible: MediaService && MediaService.trackArtUrl !== ""
                    layer.enabled: true

                    layer.effect: OpacityMask {

                        maskSource: Rectangle {
                            width: 64
                            height: 64
                            radius: 8
                        }

                    }

                }

                UiText {
                    anchors.centerIn: parent
                    text: ThemeIcons.music
                    font.pixelSize: ThemeFonts.lg
                    color: ThemeColors.fgPrimary
                    visible: !MediaService || MediaService.trackArtUrl === ""
                }

            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                // Clickable Title and Artist section
                Item {
                    Layout.fillWidth: true
                    implicitHeight: titleColumn.implicitHeight

                    ColumnLayout {
                        id: titleColumn

                        anchors.fill: parent
                        spacing: 2

                        UiText {
                            Layout.fillWidth: true
                            text: MediaService && MediaService.trackTitle ? MediaService.trackTitle : "No media playing"
                            color: titleMouseArea.containsMouse ? ThemeColors.accentPrimary : ThemeColors.fgPrimary
                            font.pixelSize: ThemeFonts.sm
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        UiText {
                            Layout.fillWidth: true
                            text: MediaService && MediaService.trackArtist ? MediaService.trackArtist : "Unknown artist"
                            color: ThemeColors.fgMuted
                            font.pixelSize: ThemeFonts.xs
                            elide: Text.ElideRight
                        }

                    }

                    MouseArea {
                        id: titleMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: (MediaService && MediaService.activePlayer && MediaService.activePlayer.canRaise) ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            if (MediaService)
                                MediaService.focusPlayerWindow();

                        }
                    }

                }

                // Player selection row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    spacing: 6
                    visible: MediaService ? MediaService.availablePlayers.length > 1 : false

                    Repeater {
                        model: MediaService ? MediaService.availablePlayers : []

                        delegate: Rectangle {
                            required property MprisPlayer modelData

                            width: 24
                            height: 24
                            radius: 4
                            color: MediaService.activePlayer === modelData ? ThemeColors.bgButtonHover : "transparent"
                            border.color: MediaService.activePlayer === modelData ? ThemeColors.borderBase : "transparent"
                            border.width: 1

                            UiText {
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

            }

        }

        // Progress bar with current position and total duration
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            visible: MediaService && MediaService.length > 0

            Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: ThemeColors.bgSurfaceActive

                Rectangle {
                    width: parent.width * (MediaService ? MediaService.progress : 0)
                    height: parent.height
                    radius: 2
                    color: ThemeColors.accentPrimary
                }

            }

            RowLayout {
                Layout.fillWidth: true

                // Current position timestamp
                UiText {
                    text: MediaService ? MediaService.formatTime(MediaService.position) : "0:00"
                    color: ThemeColors.fgMuted
                    font.pixelSize: ThemeFonts.xs
                }

                Item {
                    Layout.fillWidth: true
                }

                // Total duration timestamp
                UiText {
                    text: MediaService ? MediaService.formatTime(MediaService.length) : "0:00"
                    color: ThemeColors.fgMuted
                    font.pixelSize: ThemeFonts.xs
                }

            }

        }

        // Playback controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            UiButton {
                Layout.fillWidth: true
                enabled: null != MediaService
                onClicked: MediaService.previous()
                text: ThemeIcons.skipPrevious
            }

            UiButton {
                Layout.fillWidth: true
                enabled: null != MediaService
                onClicked: MediaService.togglePlaying()
                text: (MediaService && MediaService.isPlaying) ? ThemeIcons.pause : ThemeIcons.play
            }

            UiButton {
                Layout.fillWidth: true
                enabled: null != MediaService
                onClicked: MediaService.next()
                text: ThemeIcons.skipNext
            }

        }

    }

}
