import QtQuick

Item {
    id: root

    required property var server
    property var notifications: []
    property var popupNotifications: []
    property int nextId: 0

    function removePopup(id) {
        let list = root.popupNotifications.slice();
        for (let i = 0; i < list.length; ++i) {
            if (list[i].id === id) {
                list.splice(i, 1);
                break;
            }
        }
        root.popupNotifications = list;
    }

    function removeNotification(id) {
        let list = root.notifications.slice();
        for (let i = 0; i < list.length; ++i) {
            if (list[i].id === id) {
                list.splice(i, 1);
                break;
            }
        }
        root.notifications = list;
        root.removePopup(id);
    }

    function invokeAction(item, actionIndex) {
        if (!item || !item._notification)
            return ;

        const index = Number(actionIndex);
        if (index < 0 || index >= item._notification.actions.length)
            return ;

        const action = item._notification.actions[index];
        if (!action)
            return ;

        action.invoke();
        root.removeNotification(item.id);
    }

    function clearAll() {
        const list = root.notifications.slice();
        for (let i = 0; i < list.length; ++i) {
            if (list[i] && list[i]._notification)
                list[i]._notification.dismiss();

        }
        root.notifications = [];
        root.popupNotifications = [];
    }

    Connections {
        function onNotification(notification) {
            if (!notification)
                return ;

            notification.tracked = true;
            const actions = [];
            for (let i = 0; i < notification.actions.length; ++i) {
                const action = notification.actions[i];
                if (!action)
                    continue;

                actions.push({
                    "index": i,
                    "text": action.text || ("Action " + (i + 1))
                });
            }
            const item = {
                "id": root.nextId++,
                "appName": notification.appName || "",
                "summary": notification.summary || "",
                "body": notification.body || "",
                "actions": actions,
                "_notification": notification
            };
            let history = root.notifications.slice();
            history.unshift(item);
            root.notifications = history;
            let popups = root.popupNotifications.slice();
            popups.push(item);
            root.popupNotifications = popups;
        }

        target: root.server
    }

}
