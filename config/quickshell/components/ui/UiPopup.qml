import "../../theme"
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property real barHeight
    required property bool isPrimaryScreen
    property string popupPosition: "top-right"
    property real widgetX: 0
    property real widgetWidth: 0
    property real minWidth: 100
    property real minHeight: 100
    property bool isOpened: false
    default property alias content: innerItem.children

    function toggle() {
        isOpened = !isOpened;
    }

    visible: isOpened && isPrimaryScreen
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    focusable: true

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    MouseArea {
        anchors.fill: parent
        z: 0
        onClicked: root.isOpened = false
    }

    Rectangle {
        id: contentContainer

        implicitWidth: Math.max(root.minWidth, innerItem.implicitWidth + 24)
        implicitHeight: Math.max(root.minHeight, innerItem.implicitHeight + 24)
        color: ThemeColors.bgBase
        border.color: ThemeColors.borderBase
        border.width: 1
        radius: 8
        x: {
            if (0 < root.widgetX && 0 < root.widgetWidth) {
                return Math.max(16, root.widgetX + (root.widgetWidth / 2) - (width / 2));
            } else {
                switch (root.popupPosition) {
                case "top-left":
                    return 16;
                case "top-center":
                    return (parent.width / 2) - (width / 2);
                case "top-right":
                default:
                    return parent.width - width - 16;
                }
            }
        }
        y: root.barHeight
        z: 1

        Item {
            id: innerItem

            anchors.fill: parent
            anchors.margins: 12
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }

    }

}
