import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets

Item {
    id: root

    required property var notification
    property bool hasBorderRadius: true
    property var notif: root.notification && root.notification._notification ? root.notification._notification : null
    property string timestamp: root.notification && root.notification.timestamp ? root.notification.timestamp : ""
    property var relevantActions: {
        if (!root.notif || !root.notif.actions)
            return [];

        return root.notif.actions.filter((action) => {
            var id = (action.identifier || action.id || "").toLowerCase();
            return id !== "default" && id !== "view";
        });
    }

    signal removeRequested(var notification)
    signal actionRequested(var notification, int actionIndex)

    function invokeDefaultAction() {
        if (!root.notif || !root.notif.actions)
            return false;

        for (var i = 0; i < root.notif.actions.length; i++) {
            var action = root.notif.actions[i];
            var id = (action.identifier || action.id || "").toLowerCase();
            if (id === "default" || id === "view") {
                root.actionRequested(root.notification, i);
                return true;
            }
        }
        return false;
    }

    implicitHeight: content.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        radius: root.hasBorderRadius ? 16 : 0
        color: hoverArea.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgBase
        border.width: 1
        border.color: ThemeColors.borderBase
        visible: root.notif !== null

        Rectangle {
            width: 3
            radius: 2
            color: ThemeColors.urgent
            visible: root.notif !== null && root.notif.urgency === NotificationUrgency.Critical

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                topMargin: root.hasBorderRadius ? 16 : 0
                bottomMargin: root.hasBorderRadius ? 16 : 0
            }

        }

        MouseArea {
            id: hoverArea

            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (!root.invokeDefaultAction())
                    mouse.accepted = false;

            }
        }

        ColumnLayout {
            id: content

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                leftMargin: 18
                rightMargin: 10
                topMargin: 12
                bottomMargin: 12
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Icon container with automatic Fallback
                Item {
                    Layout.preferredWidth: 38
                    Layout.preferredHeight: 38
                    Layout.alignment: Qt.AlignTop

                    Image {
                        id: iconImage

                        fillMode: Image.PreserveAspectFit
                        asynchronous: true
                        source: {
                            if (!root.notif)
                                return "";

                            var image = root.notif.image || root.notif.appIcon || "";
                            if (!image)
                                return "";

                            if (image.startsWith("/"))
                                return "file://" + image;

                            if (image.startsWith("file://") || image.startsWith("image://"))
                                return image;

                            return "image://icon/" + image;
                        }
                        visible: status === Image.Ready

                        anchors {
                            fill: parent
                            topMargin: 5
                        }

                    }

                    // Fallback
                    Rectangle {
                        radius: 10
                        color: ThemeColors.fgPrimary
                        visible: !iconImage.visible

                        anchors {
                            fill: parent
                            topMargin: 5
                        }

                        UiText {
                            anchors.centerIn: parent
                            text: root.notif && root.notif.appName ? root.notif.appName.charAt(0).toUpperCase() : "!"
                            color: ThemeColors.fgOnAccent
                            font.pixelSize: ThemeFonts.md
                            font.bold: true
                        }

                    }

                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        UiText {
                            Layout.fillWidth: true
                            text: root.notif ? root.notif.appName.charAt(0).toUpperCase() + root.notif.appName.slice(1) || "" : ""
                            color: ThemeColors.fgMuted
                            font.pixelSize: ThemeFonts.xs
                            elide: Text.ElideRight
                        }

                        UiText {
                            text: root.timestamp
                            color: ThemeColors.fgMuted
                            font.pixelSize: ThemeFonts.xs
                        }

                        UiButton {
                            text: ThemeIcons.cross
                            onClicked: root.removeRequested(root.notification)
                        }

                    }

                    UiText {
                        Layout.fillWidth: true
                        text: root.notif ? root.notif.summary || "Notification" : ""
                        color: ThemeColors.fgPrimary
                        font.pixelSize: ThemeFonts.sm
                        font.bold: true
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                    }

                    UiText {
                        Layout.fillWidth: true
                        text: root.notif ? root.notif.body || "" : ""
                        color: ThemeColors.fgMuted
                        font.pixelSize: ThemeFonts.sm
                        maximumLineCount: 4
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                    }

                }

            }

            // Actions
            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                visible: root.relevantActions.length > 0

                Repeater {
                    model: root.relevantActions

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                        radius: 8
                        color: actionMouse.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgBase

                        UiText {
                            anchors.centerIn: parent
                            text: modelData.text || modelData.label || modelData.id || "Action"
                            color: ThemeColors.fgPrimary
                            font.pixelSize: ThemeFonts.xs
                            elide: Text.ElideRight
                        }

                        MouseArea {
                            id: actionMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.actionRequested(root.notification, modelData.index)
                        }

                    }

                }

            }

        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }

        }

    }

}
