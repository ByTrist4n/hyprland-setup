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
    PanelWindow {
        id: root

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
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
                spacing: 8

                BarWorkspaces {
                }

                BarMusic {
                }

                Item {
                    Layout.fillWidth: true
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
        manager: notificationManager
    }

    NotificationCenter {
        id: notificationCenter

        manager: notificationManager
    }

    NetworkPopup {
        id: networkPopup

        barHeight: barContainer.height
    }

}
