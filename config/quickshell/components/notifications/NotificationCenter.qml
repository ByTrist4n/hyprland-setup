import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var manager
    required property real barHeight
    required property bool isPrimaryScreen
    property bool isOpened: false

    function toggle() {
        isOpened = !isOpened;
    }

    visible: isOpened && isPrimaryScreen
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
        onClicked: root.isOpened = false
    }

    Rectangle {
        id: popup

        z: 1
        clip: true
        width: 380
        height: Math.min(contentColumn.implicitHeight + 28, 700)
        radius: 8
        color: ThemeColors.bgBase
        border.width: 1
        border.color: ThemeColors.borderBase

        anchors {
            top: parent.top
            right: parent.right
            topMargin: root.barHeight
            rightMargin: 16
        }

        ColumnLayout {
            id: contentColumn

            spacing: 0

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            // Header
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 58

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    anchors.rightMargin: 12
                    spacing: 8

                    UiText {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: ThemeColors.fgPrimary
                        font.pixelSize: ThemeFonts.lg
                        font.bold: true
                    }

                    Rectangle {
                        implicitWidth: clearRow.implicitWidth + 12
                        implicitHeight: 28
                        radius: 8
                        color: clearMouseArea.containsMouse ? ThemeColors.bgButtonHover : "transparent"
                        visible: manager.notifications.length > 0

                        RowLayout {
                            id: clearRow

                            anchors.centerIn: parent
                            spacing: 6

                            UiText {
                                text: manager.notifications.length
                                color: ThemeColors.fgPrimary
                                font.pixelSize: ThemeFonts.sm
                                font.bold: true
                                Layout.alignment: Qt.AlignBottom
                            }

                            UiText {
                                text: ThemeIcons.clean
                                color: ThemeColors.fgPrimary
                                font.pixelSize: ThemeFonts.lg
                                Layout.alignment: Qt.AlignBottom
                            }

                        }

                        MouseArea {
                            id: clearMouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: manager.clearAll()
                        }

                    }

                    UiButton {
                        contentText: ThemeIcons.cross
                        onClicked: root.toggle()
                    }

                }

            }

            // Separator
            Rectangle {
                id: separator

                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: ThemeColors.borderBase
            }

            // Empty state
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                visible: manager.notifications.length === 0

                UiText {
                    anchors.centerIn: parent
                    text: "No notification"
                    color: ThemeColors.fgMuted
                    font.pixelSize: ThemeFonts.sm
                }

            }

            // Notification list
            ListView {
                id: notificationList

                Layout.fillWidth: true
                height: Math.min(contentHeight, 600)
                visible: manager.notifications.length > 0
                clip: true
                spacing: 4
                bottomMargin: 8
                topMargin: 4
                model: manager.notifications

                delegate: NotificationItem {
                    required property var modelData

                    hasBorderRadius: false
                    width: notificationList.width
                    notification: modelData
                    onRemoveRequested: manager.removeNotification(modelData)
                    onActionRequested: (id, actionId) => {
                        return manager.invokeAction(modelData, actionId);
                    }
                }

            }

        }

    }

}
