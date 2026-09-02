import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: root

    required property var manager

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window

            required property var modelData

            screen: modelData
            visible: manager.popupNotifications.length > 0
            color: "transparent"
            implicitWidth: 380
            implicitHeight: popupList.contentHeight
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

            ListView {
                id: popupList

                anchors.fill: parent
                model: manager.popupNotifications
                spacing: 8
                interactive: false

                delegate: Item {
                    required property var modelData

                    width: popupList.width
                    height: notificationItem.implicitHeight

                    NotificationItem {
                        id: notificationItem

                        anchors.fill: parent
                        notification: modelData
                        onRemoveRequested: (id) => {
                            manager.removeNotification(id);
                        }
                        onActionRequested: (id, actionId) => {
                            manager.invokeAction(modelData, actionId);
                        }
                    }

                    Timer {
                        interval: 5000
                        running: true
                        repeat: false
                        onTriggered: {
                            manager.removePopup(modelData.id);
                        }
                    }

                }

            }

        }

    }

}
