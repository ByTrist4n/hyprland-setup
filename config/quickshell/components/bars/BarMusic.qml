import "../../services"
import "../../theme"
import "../ui"
import "../widgets"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    implicitWidth: musicRow.implicitWidth + 16
    implicitHeight: musicRow.implicitHeight + 16
    color: musicMouseArea.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgBase
    radius: 8
    border.color: ThemeColors.borderBase
    border.width: 1
    visible: MediaService.hasMedia

    RowLayout {
        id: musicRow

        anchors.centerIn: parent
        spacing: 16

        RowLayout {
            spacing: 6

            // Status icon
            UiText {
                text: MediaService.isPlaying ? ThemeIcons.music : ThemeIcons.musicOff
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.sm
                Layout.preferredWidth: 16
                horizontalAlignment: Text.AlignHCenter
            }

            // Track title
            UiText {
                text: MediaService.trackTitle || "Unknown title"
                Layout.maximumWidth: 200
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.sm
                font.bold: true
                elide: Text.ElideRight
            }

            // Track artist
            UiText {
                text: "- " + (MediaService.trackArtist || "Unknown artist")
                Layout.maximumWidth: 150
                color: ThemeColors.fgMuted
                font.pixelSize: ThemeFonts.xs
                elide: Text.ElideRight
            }

        }

        // Audio visualizer widget
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
