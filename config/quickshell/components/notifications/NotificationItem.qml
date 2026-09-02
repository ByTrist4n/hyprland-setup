import "../../theme"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property var notification

    signal removeRequested(int id)
    signal actionRequested(int id, string actionId)

    implicitHeight: content.implicitHeight + 24

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: ThemeColor.bgBase
        border.width: 1
        border.color: ThemeColor.borderBase

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

                Rectangle {
                    Layout.preferredWidth: 38
                    Layout.preferredHeight: 38
                    Layout.alignment: Qt.AlignTop
                    radius: 10
                    color: ThemeColor.fgPrimary

                    Text {
                        anchors.centerIn: parent
                        text: root.notification.appName ? root.notification.appName.charAt(0).toUpperCase() : "!"
                        color: ThemeColor.fgOnAccent
                        font.pixelSize: ThemeFont.md
                        font.bold: true
                    }

                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.summary || "Notification"
                        color: ThemeColor.accentPrimary
                        font.pixelSize: ThemeFont.sm
                        font.bold: true
                        maximumLineCount: 2
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.body || ""
                        color: ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.sm
                        wrapMode: Text.Wrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.notification.appName || ""
                        color: ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.xs
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }

                }

                Rectangle {
                    Layout.preferredWidth: 28
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignTop
                    radius: 8
                    color: deleteMouse.containsMouse ? ThemeColor.bgSurfaceHover : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.lg
                    }

                    MouseArea {
                        id: deleteMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.removeRequested(root.notification.id);
                        }
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
                        color: actionMouse.containsMouse ? ThemeColor.bgSurfaceHover : ThemeColor.bgSurface

                        Text {
                            anchors.centerIn: parent
                            text: modelData.text || modelData.label || modelData.id || "Action"
                            color: ThemeColor.fgPrimary
                            font.pixelSize: ThemeFont.xs
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
