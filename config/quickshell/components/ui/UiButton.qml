import "../../theme"
import QtQuick
import QtQuick.Controls

Button {
    id: root

    property string textButton: ""
    property color activeColor: ThemeColor.fgPrimary
    property color disabledColor: ThemeColor.fgMuted
    property real pixelSize: ThemeFont.lg
    property color hoverBgColor: ThemeColor.bgSurfaceActive
    property color defaultBgColor: "transparent"

    flat: true

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    background: Rectangle {
        implicitWidth: 32
        implicitHeight: 32
        color: root.hovered ? root.hoverBgColor : root.defaultBgColor
        radius: 6

        Behavior on color {
            ColorAnimation {
                duration: 150
            }

        }

    }

    contentItem: Text {
        text: root.textButton
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: root.pixelSize
        color: root.enabled ? root.activeColor : root.disabledColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

}
