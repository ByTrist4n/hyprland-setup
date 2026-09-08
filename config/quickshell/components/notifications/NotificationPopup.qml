import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var manager
    required property real barHeight
    required property bool isPrimaryScreen

    visible: manager.popupNotifications.length > 0 && isPrimaryScreen
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
        top: root.barHeight
        right: 16
    }

    ListView {
        id: popupList

        width: parent.width
        height: contentHeight
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
                    return manager.removeNotification(id);
                }
                onActionRequested: (id, actionId) => {
                    return manager.invokeAction(modelData, actionId);
                }
            }

            Timer {
                interval: 3000
                running: true
                repeat: false
                onTriggered: manager.removePopup(modelData.id)
            }

        }

    }

}
