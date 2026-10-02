import "../../services"
import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var batteryPopup: null
    property real simPercent: 0.75
    property bool simIsCharging: false
    // Effective state based on physical battery availability
    readonly property bool activeAvailable: BatteryService.isAvailable
    readonly property real activePercent: BatteryService.isAvailable ? BatteryService.percent : simPercent
    readonly property bool activeIsCharging: BatteryService.isAvailable ? BatteryService.isCharging : simIsCharging

    visible: activeAvailable
    implicitWidth: visible ? (batteryRow.implicitWidth + 24) : 0
    implicitHeight: visible ? 40 : 0
    radius: 8
    color: batteryMouseArea.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgBase
    border.width: 1
    border.color: ThemeColors.borderBase

    RowLayout {
        id: batteryRow

        anchors.centerIn: parent
        spacing: 6

        UiText {
            text: {
                if (root.activeIsCharging)
                    return ThemeIcons.batteryCharging;

                const percent = root.activePercent;
                if (percent <= 0.1)
                    return ThemeIcons.battery0;

                if (percent <= 0.2)
                    return ThemeIcons.battery10;

                if (percent <= 0.3)
                    return ThemeIcons.battery20;

                if (percent <= 0.4)
                    return ThemeIcons.battery30;

                if (percent <= 0.5)
                    return ThemeIcons.battery40;

                if (percent <= 0.6)
                    return ThemeIcons.battery50;

                if (percent <= 0.7)
                    return ThemeIcons.battery60;

                if (percent <= 0.8)
                    return ThemeIcons.battery70;

                if (percent <= 0.9)
                    return ThemeIcons.battery80;

                return ThemeIcons.battery90;
            }
            color: {
                if (root.activePercent <= 0.15 && !root.activeIsCharging)
                    return ThemeColors.urgent;

                return root.activeIsCharging ? ThemeColors.warning : ThemeColors.accentPrimary;
            }
            font.pixelSize: ThemeFonts.lg
        }

        UiText {
            text: Math.round(root.activePercent * 100) + "%"
            color: ThemeColors.fgPrimary
            font.pixelSize: ThemeFonts.sm
            font.bold: true
        }

    }

    MouseArea {
        id: batteryMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

}
