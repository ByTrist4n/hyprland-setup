import "../../services"
import "../../theme"
import "../widgets"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Rectangle {
    id: root

    implicitWidth: musicRow.implicitWidth + 16
    implicitHeight: musicRow.implicitHeight + 16
    color: musicMouseArea.containsMouse ? ThemeColors.bgSurfaceActive : ThemeColors.bgSurface
    radius: 8
    border.color: ThemeColors.borderBase
    border.width: 1

    RowLayout {
        id: musicRow

        anchors.centerIn: parent
        spacing: 16

        RowLayout {
            spacing: 6

            Text {
                text: MediaService.isPlaying ? ThemeIcons.music : ThemeIcons.musicOff
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.sm
                // Prevent width collapse during icon switch
                Layout.preferredWidth: 16
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: MediaService.trackTitle
                Layout.maximumWidth: 200
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.sm
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                text: "- " + MediaService.trackArtist
                Layout.maximumWidth: 150
                color: ThemeColors.fgMuted
                font.pixelSize: ThemeFonts.xs
                elide: Text.ElideRight
            }

        }

        CavaVisualizer {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
        }

    }

    MouseArea {
        id: musicMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: musicPopup.isOpened = !musicPopup.isOpened
    }

}
