import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Item {
    id: root

    required property var notification
    property bool hasBorderRadius: true

    signal removeRequested(int id)
    signal actionRequested(int id, string actionId)

    implicitHeight: content.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        radius: root.hasBorderRadius ? 8 : 0
        color: ThemeColors.bgSurface
        border.width: 1
        border.color: ThemeColors.borderBase

        ColumnLayout {
            id: content

            spacing: 8

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                leftMargin: 14
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

                    IconImage {
                        id: iconImage

                        anchors.fill: parent
                        source: root.notification.appIcon || ""
                        visible: status === Image.Ready
                    }

                    // Fallback
                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: ThemeColors.fgPrimary
                        visible: !iconImage.visible || iconImage.status === Image.Error

                        Text {
                            anchors.centerIn: parent
                            text: root.notification.appName ? root.notification.appName.charAt(0).toUpperCase() : "!"
                            color: ThemeColors.fgOnAccent
                            font.pixelSize: ThemeFonts.md
                            font.bold: true
                        }

                    }

                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.summary || "Notification"
                        color: ThemeColors.accentPrimary
                        font.pixelSize: ThemeFonts.sm
                        font.bold: true
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.body || ""
                        color: ThemeColors.fgPrimary
                        font.pixelSize: ThemeFonts.sm
                        wrapMode: Text.Wrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.appName || ""
                        color: ThemeColors.fgPrimary
                        font.pixelSize: ThemeFonts.xs
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }

                }

                UiButton {
                    contentText: ThemeIcons.cross
                    onClicked: {
                        root.removeRequested(root.notification.id);
                    }
                }

            }

            // ACTIONS
            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                visible: root.notification.actions && root.notification.actions.length > 0

                Repeater {
                    model: root.notification.actions

                    delegate: Rectangle {
                        required property var modelData

                        Layout.preferredHeight: 30
                        Layout.fillWidth: true
                        radius: 8
                        color: actionMouse.containsMouse ? ThemeColors.bgSurfaceActive : ThemeColors.bgSurface

                        Text {
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
                            onClicked: {
                                root.actionRequested(root.notification.id, modelData.index);
                            }
                        }

                    }

                }

            }

        }

    }

}
