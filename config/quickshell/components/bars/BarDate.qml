import "../../components/widgets"
import "../../theme"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: clockPill

    anchors.centerIn: parent
    implicitWidth: clockLayout.implicitWidth + 16
    implicitHeight: clockLayout.implicitHeight + 16
    color: clockMouseArea.containsMouse ? ThemeColor.bgSurfaceHover : ThemeColor.bgSurface
    radius: 8
    border.color: ThemeColor.borderBase
    border.width: 1

    RowLayout {
        id: clockLayout

        anchors.centerIn: parent
        spacing: 6

        Text {
            text: "󰃭"
            color: ThemeColor.accentPrimary
            font.pixelSize: ThemeFont.lg
        }

        Text {
            id: clockText

            text: clockTimer.timeString
            color: ThemeColor.fgPrimary
            font.pixelSize: ThemeFont.sm
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
        onClicked: {
            calendarPopup.toggle();
        }
    }

    Calendar {
        id: calendarPopup

        targetItem: clockPill
    }

}
