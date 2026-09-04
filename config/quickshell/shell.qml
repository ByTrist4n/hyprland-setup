import "./components/bars"
import "./components/notifications"
import "./components/widgets"
import "./theme"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root

            required property var modelData
            readonly property real popupBarHeight: barContainer.height + 12
            readonly property bool isPrimaryScreen: modelData === Quickshell.screens[0]

            screen: modelData
            implicitHeight: barContainer.implicitHeight
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                top: 8
                left: 12
                right: 12
            }

            Rectangle {
                id: barContainer

                anchors.fill: parent
                implicitHeight: barRow.implicitHeight + 16
                color: ThemeColor.bgBase
                radius: 16
                border.width: 1
                border.color: ThemeColor.borderBase

                RowLayout {
                    id: barRow

                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    BarWorkspaces {
                    }

                    BarMusic {
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    BarVolume {
                        id: barVolume

                        volumePopup: volumePopup
                    }

                    BarNetwork {
                        id: barNetwork

                        networkPopup: networkPopup
                    }

                }

                BarDate {
                    id: barDate

                    anchors.centerIn: parent
                }

                BarNotification {
                    id: barNotification

                    anchors.left: barDate.right
                    anchors.leftMargin: 8
                    anchors.verticalCenter: barDate.verticalCenter
                    notificationManager: notificationManager
                    notificationCenter: notificationCenter
                }

            }

            NotificationServer {
                id: server

                bodySupported: true
                bodyMarkupSupported: false
                actionsSupported: true
            }

            NotificationManager {
                id: notificationManager

                server: server
            }

            NotificationPopup {
                barHeight: root.popupBarHeight
                manager: notificationManager
                isPrimaryScreen: root.isPrimaryScreen
            }

            NotificationCenter {
                id: notificationCenter

                barHeight: root.popupBarHeight
                manager: notificationManager
                isPrimaryScreen: root.isPrimaryScreen
            }

            VolumePopup {
                id: volumePopup

                barHeight: root.popupBarHeight
                isPrimaryScreen: root.isPrimaryScreen
            }

            NetworkPopup {
                id: networkPopup

                barHeight: root.popupBarHeight
                isPrimaryScreen: root.isPrimaryScreen
            }

        }

    }

}
