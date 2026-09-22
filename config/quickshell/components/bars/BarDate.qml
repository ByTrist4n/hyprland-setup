import "../../theme"
import "../ui"
import "../widgets"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: root

    anchors.centerIn: parent
    implicitWidth: clockLayout.implicitWidth + 16
    implicitHeight: clockLayout.implicitHeight + 16
    color: clockMouseArea.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgSurface
    radius: 8
    border.color: ThemeColors.borderBase
    border.width: 1

    RowLayout {
        id: clockLayout

        anchors.centerIn: parent
        spacing: 6

        UiText {
            text: "󰃭"
            color: ThemeColors.accentPrimary
            font.pixelSize: ThemeFonts.lg
        }

        UiText {
            id: clockText

            text: clockTimer.timeString
            color: ThemeColors.fgPrimary
            font.pixelSize: ThemeFonts.sm
            font.bold: true
        }

    }

    Timer {
        id: clockTimer

        property string timeString: ""

        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            timeString = Qt.formatDateTime(new Date(), "ddd, dd MMM - hh:mm AP");
        }
    }

    MouseArea {
        id: clockMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: calendarPopup.toggle()
    }

}
