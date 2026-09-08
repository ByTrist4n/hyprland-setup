import QtQuick

Item {
    id: root

    required property var server
    property var notifications: []
    property var popupNotifications: []
    property int nextId: 0

    function removePopup(id) {
        root.popupNotifications = root.popupNotifications.filter(function(item) {
            return item.id !== id;
        });
    }

    function removeNotification(id) {
        root.notifications = root.notifications.filter(function(item) {
            return item.id !== id;
        });
        root.removePopup(id);
    }

    function invokeAction(item, actionIndex) {
        if (!item || !item._notification)
            return ;

        const index = Number(actionIndex);
        const actions = item._notification.actions;
        if (isNaN(index) || index < 0 || !actions || index >= actions.length)
            return ;

        const action = actions[index];
        if (action && typeof action.invoke === "function")
            action.invoke();

        root.removeNotification(item.id);
    }

    function clearAll() {
        root.notifications.forEach(function(item) {
            if (item && item._notification && typeof item._notification.dismiss === "function")
                item._notification.dismiss();

        });
        root.notifications = [];
        root.popupNotifications = [];
    }

    Connections {
        function onNotification(notification) {
            if (!notification)
                return ;

            notification.tracked = true;
            const actions = (notification.actions || []).map(function(action, i) {
                if (!action)
                    return null;

                return {
                    "index": i,
                    "text": action.text || ("Action " + (i + 1))
                };
            }).filter(Boolean);
            const item = {
                "id": root.nextId++,
                "appName": notification.appName || "",
                "appIcon": notification.image || "",
                "summary": notification.summary || "",
                "body": notification.body || "",
                "actions": actions,
                "_notification": notification
            };
            // Prepend to history, append to popups without spread operator
            root.notifications = [item].concat(root.notifications);
            root.popupNotifications = root.popupNotifications.concat([item]);
        }

        target: root.server
    }

}
