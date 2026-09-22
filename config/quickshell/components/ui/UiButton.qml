import "../../theme"
import QtQuick
import QtQuick.Controls

Button {
    id: root

    property color fgColor: ThemeColors.fgPrimary
    property color fgDisabled: ThemeColors.fgMuted
    property color bgNormal: "transparent"
    property color bgHover: ThemeColors.bgButtonHover
    property real pixelSize: ThemeFonts.lg
    property bool hasBorder: false

    flat: true
    padding: 4
    leftPadding: 8
    rightPadding: 8

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
    }

    background: Rectangle {
        implicitWidth: 12
        implicitHeight: 12
        color: root.hovered ? root.bgHover : root.bgNormal
        radius: 8
        border.width: root.hasBorder ? 1 : 0
        border.color: ThemeColors.borderBase

        Behavior on color {
            ColorAnimation {
                duration: 150
            }

        }

    }

    contentItem: UiText {
        text: root.text
        font.pixelSize: root.pixelSize
        color: root.enabled ? root.fgColor : root.fgDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

}
