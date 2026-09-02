import "../../theme"
import "../widgets"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris

Rectangle {
    id: root

    // Fetch the active MPRIS player or fallback to first available
    property MprisPlayer activePlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    implicitWidth: musicRow.implicitWidth + 16
    implicitHeight: musicRow.implicitHeight + 16
    color: ThemeColor.bgSurface
    radius: 8
    border.color: ThemeColor.borderBase
    border.width: 1

    RowLayout {
        id: musicRow

        anchors.centerIn: parent
        spacing: 12

        // Track Title
        Text {
            text: root.activePlayer && root.activePlayer.trackTitle ? root.activePlayer.trackTitle : "No media playing"
            color: ThemeColor.fgPrimary
            font.pixelSize: ThemeFont.sm
            font.bold: true
            elide: Text.ElideRight
        }

        // Artist Name
        Text {
            text: "- " + (root.activePlayer && root.activePlayer.trackArtist ? root.activePlayer.trackArtist : "Unknown artist")
            color: ThemeColor.fgMuted
            font.pixelSize: ThemeFont.xs
            elide: Text.ElideRight
        }

        CavaVisualizer {
            Layout.preferredWidth: 120
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
        }

    }

}
