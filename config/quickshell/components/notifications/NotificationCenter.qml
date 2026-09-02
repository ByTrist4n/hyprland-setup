import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    required property var manager
    property bool opened: false

    function toggle() {
        opened = !opened;
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            required property var modelData

            screen: modelData
            visible: root.opened
            color: "transparent"
            implicitWidth: 380
            implicitHeight: Math.min(centerColumn.implicitHeight, 700)
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore

            anchors {
                top: true
                right: true
            }

            margins {
                top: 16
                right: 16
            }

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: ThemeColor.bgBase
                border.width: 1
                border.color: ThemeColor.borderBase

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

    }

}
