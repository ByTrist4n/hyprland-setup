import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var manager
    required property real barHeight
    required property bool isPrimaryScreen
    property bool opened: false

    function toggle() {
        opened = !opened;
    }

    visible: opened && isPrimaryScreen
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    focusable: true

    // Fullscreen backdrop to handle click outside
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    MouseArea {
        anchors.fill: parent
        z: 0
        onClicked: {
            root.opened = false;
        }
    }

    Rectangle {
        id: popup

        z: 1
        width: 360
        height: Math.min(centerColumn.implicitHeight + 28, 700)
        radius: 12
        color: ThemeColor.bgBase
        border.width: 1
        border.color: ThemeColor.borderBase

        anchors {
            top: parent.top
            right: parent.right
            topMargin: root.barHeight
            rightMargin: 16
        }

        ColumnLayout {
            id: centerColumn

            spacing: 0

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 58

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 12

                    Text {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.lg
                        font.bold: true
                    }

                    Text {
                        visible: manager.notifications.length > 0
                        text: manager.notifications.length
                        color: ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.sm
                    }

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 8
                        color: clearMouse.containsMouse ? ThemeColor.bgSurfaceHover : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "󰃢"
                            color: ThemeColor.fgPrimary
                            font.pixelSize: ThemeFont.lg
                        }

                        MouseArea {
                            id: clearMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                manager.clearAll();
                            }
                        }

                    }

                }

            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: ThemeColor.borderBase
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                visible: manager.notifications.length === 0

                Text {
                    anchors.centerIn: parent
                    text: "Aucune notification"
                    color: ThemeColor.fgMuted
                    font.pixelSize: ThemeFont.sm
                }

            }

            ListView {
                id: notificationList

                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, 640)
                visible: manager.notifications.length > 0
                clip: true
                spacing: 8
                model: manager.notifications

                delegate: NotificationItem {
                    required property var modelData

                    width: notificationList.width
                    notification: modelData
                    onRemoveRequested: (id) => {
                        manager.removeNotification(id);
                    }
                    onActionRequested: (id, actionId) => {
                        manager.invokeAction(modelData, actionId);
                    }
                }

            }

        }

    }

}
