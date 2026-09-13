import "../../theme"
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var networkPopup

    implicitWidth: networkRow.implicitWidth + 24
    implicitHeight: networkRow.implicitHeight + 16
    radius: 10
    color: networkMouseArea.containsMouse ? ThemeColors.bgSurfaceActive : ThemeColors.bgSurface
    border.width: 1
    border.color: ThemeColors.borderBase

    RowLayout {
        id: networkRow

        anchors.centerIn: parent
        spacing: 8

        Text {
            text: networkPopup.wifiDevice && networkPopup.wifiDevice.connected ? ThemeIcons.wifi : ThemeIcons.wifiAlert
            color: ThemeColors.accentPrimary
            font.pixelSize: ThemeFonts.lg
        }

        Text {
            text: networkPopup.bluetoothAdapter && networkPopup.bluetoothAdapter.enabled ? ThemeIcons.bluetooth : ThemeIcons.bluetoothOff
            color: networkPopup.bluetoothAdapter && networkPopup.bluetoothAdapter.enabled ? ThemeColors.accentPrimary : ThemeColors.fgMuted
            font.pixelSize: ThemeFonts.lg
        }

    }

    MouseArea {
        id: networkMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: networkPopup.isOpened = !networkPopup.isOpened
    }

}
