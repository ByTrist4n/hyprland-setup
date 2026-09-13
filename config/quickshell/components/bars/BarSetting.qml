import "../../theme"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Rectangle {
    id: root

    implicitWidth: settingRow.implicitWidth + 24
    implicitHeight: settingRow.implicitHeight + 16
    color: settingMouseArea.containsMouse ? ThemeColors.bgSurfaceActive : ThemeColors.bgSurface
    radius: 8
    border.color: ThemeColors.borderBase
    border.width: 1

    RowLayout {
        id: settingRow

        anchors.centerIn: parent
        spacing: 16

        Text {
            id: settingIcon

            text: ThemeIcons.setting
            color: ThemeColors.accentPrimary
            font.pixelSize: ThemeFonts.lg
        }

    }

    MouseArea {
        id: settingMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch("hl.dsp.exec_cmd(\"wlogout\")");
        }
    }

}
