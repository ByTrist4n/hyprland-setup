import QtQuick
import Quickshell.Hyprland
import Quickshell.Services.Notifications

Item {
    id: root

    required property var server
    property var notifications: []
    property var popupNotifications: []

    function removeFromList(list, notificationId) {
        return list.filter((wrapper) => {
            return wrapper && wrapper._notification && wrapper._notification.id !== notificationId;
        });
    }

    function removePopup(notificationWrapper) {
        if (!notificationWrapper || !notificationWrapper._notification)
            return ;

        const notificationId = notificationWrapper._notification.id;
        root.popupNotifications = removeFromList(root.popupNotifications, notificationId);
    }

    function removeNotification(notificationWrapper) {
        if (!notificationWrapper || !notificationWrapper._notification)
            return ;

        const notification = notificationWrapper._notification;
        const notificationId = notification.id;
        root.notifications = removeFromList(root.notifications, notificationId);
        root.popupNotifications = removeFromList(root.popupNotifications, notificationId);
        if (notification.tracked)
            notification.dismiss();

    }

    function invokeAction(notificationWrapper, actionIndex) {
        if (!notificationWrapper || !notificationWrapper._notification)
            return ;

        const notification = notificationWrapper._notification;
        const actions = notification.actions;
        if (!actions || actionIndex < 0 || actionIndex >= actions.length)
            return ;

        actions[actionIndex].invoke();
        const appClass = notification.desktopEntry || "";
        if (appClass)
            Hyprland.dispatch(`hl.dsp.focus({ window = "class:${appClass}" })`);

        removeNotification(notificationWrapper);
    }

    function clearAll() {
        root.notifications.forEach((wrapper) => {
            if (wrapper && wrapper._notification && wrapper._notification.tracked)
                wrapper._notification.dismiss();

        });
        root.notifications = [];
        root.popupNotifications = [];
    }

    Connections {
        function onNotification(notification) {
            if (!notification)
                return ;

            notification.tracked = true;
            const notificationWrapper = {
                "_notification": notification,
                "timestamp": new Date().toLocaleTimeString("fr-FR", {
                    "hour": "2-digit",
                    "minute": "2-digit"
                })
            };
            root.notifications = [notificationWrapper].concat(root.notifications);
            root.popupNotifications = root.popupNotifications.concat([notificationWrapper]);
            const notificationId = notification.id;
            notification.closed.connect(function() {
                root.notifications = removeFromList(root.notifications, notificationId);
                root.popupNotifications = removeFromList(root.popupNotifications, notificationId);
            });
        }

        target: root.server
    }

}
