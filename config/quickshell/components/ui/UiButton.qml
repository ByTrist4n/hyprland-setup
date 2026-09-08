import "../../theme"
import QtQuick
import QtQuick.Controls

Button {
    id: root

    property string contentText: ""
    property color activeColor: ThemeColor.fgPrimary
    property color disabledColor: ThemeColor.fgMuted
    property real pixelSize: ThemeFont.lg
    property color hoverBgColor: ThemeColor.bgSurfaceActive
    property color defaultBgColor: "transparent"
    property bool hasBorder: false

    flat: true
    padding: 4
    leftPadding: 8
    rightPadding: 8

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    background: Rectangle {
        implicitWidth: 12
        implicitHeight: 12
        color: root.hovered ? root.hoverBgColor : root.defaultBgColor
        radius: 6
        border.width: root.hasBorder ? 1 : null
        border.color: ThemeColor.borderBase

        Behavior on color {
            ColorAnimation {
                duration: 150
            }

        }

    }

    contentItem: Text {
        text: root.contentText
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: root.pixelSize
        color: root.enabled ? root.activeColor : root.disabledColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

}
