import "../../theme"
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property real barHeight
    required property bool isPrimaryScreen
    required property real widgetX
    required property real widgetWidth
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

        implicitWidth: innerItem.childrenRect.width + 24
        implicitHeight: innerItem.childrenRect.height + 24
        color: ThemeColor.bgBase
        border.color: ThemeColor.borderBase
        border.width: 1
        radius: 8
        x: Math.max(16, root.widgetX + (root.widgetWidth / 2) - (width / 2))
        y: root.barHeight
        z: 1

        Item {
            id: innerItem

            anchors.fill: parent
            anchors.margins: 12
        }

    }

}
