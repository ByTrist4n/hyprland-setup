import QtQuick
import Quickshell.Hyprland
import Quickshell.Services.Notifications

Item {
    id: root

    required property var server
    property var notifications: []
    property var popupNotifications: []

    function removePopup(notification) {
        root.popupNotifications = root.popupNotifications.filter((n) => {
            return n !== notification;
        });
    }

    function removeNotification(notification) {
        root.notifications = root.notifications.filter((n) => {
            return n !== notification;
        });
        root.popupNotifications = root.popupNotifications.filter((n) => {
            return n !== notification;
        });
        if (notification && notification.tracked)
            notification.dismiss();

    }

    function invokeAction(notification, actionIndex) {
        if (!notification)
            return ;

        const actions = notification.actions;
        if (!actions || actionIndex < 0 || actionIndex >= actions.length)
            return ;

        actions[actionIndex].invoke();
        const appClass = notification.desktopEntry || notification.appName || "";
        if (appClass)
            Hyprland.dispatch(`hl.dsp.focus({ window = "class:${appClass}" })`);

        removeNotification(notification);
    }

    function clearAll() {
        root.notifications.forEach((n) => {
            return n.tracked = false;
        });
        root.notifications = [];
        root.popupNotifications = [];
    }

    Connections {
        function onNotification(notification) {
            if (!notification)
                return ;

            notification.tracked = true;
            root.notifications = [notification].concat(root.notifications);
            root.popupNotifications = root.popupNotifications.concat([notification]);
            notification.closed.connect(function() {
                root.notifications = root.notifications.filter((n) => {
                    return n !== notification;
                });
                root.popupNotifications = root.popupNotifications.filter((n) => {
                    return n !== notification;
                });
            });
        }

        target: root.server
    }

}
