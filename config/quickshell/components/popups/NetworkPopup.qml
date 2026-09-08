import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Wayland

UiPopup {
    id: root

    property var wifiDevice: {
        for (let i = 0; i < Networking.devices.values.length; ++i) {
            const device = Networking.devices.values[i];
            if (device.type === DeviceType.Wifi)
                return device;

        }
        return null;
    }
    property var bluetoothAdapter: Bluetooth.defaultAdapter

    minWidth: 360

    ColumnLayout {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 16

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Network"
                color: ThemeColor.fgPrimary
                font.pixelSize: ThemeFont.lg
                font.bold: true
                Layout.fillWidth: true
            }

            Rectangle {
                width: 30
                height: 30
                radius: 8
                color: closeMouse.containsMouse ? ThemeColor.bgSurfaceActive : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: "×"
                    color: ThemeColor.fgMuted
                    font.pixelSize: ThemeFont.lg
                }

                MouseArea {
                    id: closeMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.toggle();
                    }
                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeColor.borderBase
        }

        Text {
            text: "Wi-Fi"
            color: ThemeColor.accentPrimary
            font.pixelSize: ThemeFont.sm
            font.bold: true
        }

        Text {
            visible: root.wifiDevice === null
            text: "No Wi-Fi adapter"
            color: ThemeColor.fgMuted
            font.pixelSize: ThemeFont.xs
        }

        ListView {
            id: wifiList

            visible: root.wifiDevice !== null
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 180)
            clip: true
            spacing: 4
            model: root.wifiDevice ? root.wifiDevice.networks : null

            delegate: Rectangle {
                required property var modelData

                visible: modelData.known
                width: wifiList.width
                height: visible ? 46 : 0
                radius: 8
                color: modelData.connected ? ThemeColor.bgSurfaceActive : ThemeColor.bgBase

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 10
                    spacing: 10

                    Text {
                        text: modelData.connected ? ThemeIcon.wifi : ThemeIcon.wifiOff
                        color: modelData.connected ? ThemeColor.accentPrimary : ThemeColor.fgMuted
                        font.pixelSize: ThemeFont.lg
                    }

                    Text {
                        text: modelData.name
                        color: ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.sm
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        visible: modelData.connected
                        text: ThemeIcon.check
                        color: ThemeColor.success
                        font.pixelSize: ThemeFont.sm
                        font.bold: true
                    }

                    Text {
                        visible: modelData.stateChanging
                        text: "Loading…"
                        color: ThemeColor.accentPrimary
                        font.pixelSize: ThemeFont.md
                    }

                }

                MouseArea {
                    // Prevent multiple connection requests

                    id: wifiMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: !modelData.stateChanging
                    onClicked: {
                        if (!modelData.connected && !modelData.stateChanging)
                            modelData.connect();

                    }
                }

            }

        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeColor.borderBase
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Bluetooth"
                color: ThemeColor.accentSecondary
                font.pixelSize: ThemeFont.sm
                font.bold: true
                Layout.fillWidth: true
            }

            Rectangle {
                id: bluetoothToggle

                width: 42
                height: 24
                radius: 12
                color: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? ThemeColor.bgSurfaceActive : ThemeColor.bgSurfaceDisabled
                border.width: 1
                border.color: ThemeColor.borderBase

                Rectangle {
                    width: 18
                    height: 18
                    radius: 8
                    anchors.verticalCenter: parent.verticalCenter
                    x: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? parent.width - width - 3 : 3
                    color: ThemeColor.fgPrimary

                    Behavior on x {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }

                    }

                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: root.bluetoothAdapter !== null
                    onClicked: {
                        if (!root.bluetoothAdapter)
                            return ;

                        root.bluetoothAdapter.enabled = !root.bluetoothAdapter.enabled;
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }

                }

            }

        }

        ListView {
            id: bluetoothList

            visible: root.bluetoothAdapter !== null && root.bluetoothAdapter.enabled
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 180)
            clip: true
            spacing: 4
            model: root.bluetoothAdapter ? root.bluetoothAdapter.devices : null

            delegate: Rectangle {
                required property var modelData
                property bool isBusy: false

                visible: modelData.paired
                width: bluetoothList.width
                height: visible ? 46 : 0
                radius: 8
                color: modelData.connected ? ThemeColor.bgSurfaceActive : bluetoothMouse.containsMouse ? ThemeColor.bgSurfaceActive : ThemeColor.bgBase

                Connections {
                    function onConnectedChanged() {
                        isBusy = false;
                    }

                    target: modelData
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 10
                    spacing: 10

                    Text {
                        text: ThemeIcon.bluetoothConnect
                        color: modelData.connected ? ThemeColor.accentSecondary : ThemeColor.fgMuted
                        font.pixelSize: ThemeFont.lg
                    }

                    Text {
                        text: modelData.name || "Unknown device"
                        color: ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.sm
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: isBusy || modelData.connecting ? "Loading…" : ""
                        color: ThemeColor.accentSecondary
                        font.pixelSize: ThemeFont.md
                    }

                    Text {
                        visible: !isBusy && !modelData.connecting
                        text: modelData.connected ? ThemeIcon.check : ThemeColor.chevronRight
                        color: modelData.connected ? ThemeColor.success : ThemeColor.fgMuted
                        font.pixelSize: ThemeFont.md
                        font.bold: true
                    }

                }

                MouseArea {
                    id: bluetoothMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: !isBusy && !modelData.connecting
                    onClicked: {
                        if (isBusy)
                            return ;

                        isBusy = true;
                        if (modelData.connected)
                            modelData.disconnect();
                        else
                            modelData.connect();
                    }
                }

            }

        }

        Text {
            visible: root.bluetoothAdapter !== null && root.bluetoothAdapter.enabled && bluetoothList.count === 0
            text: "No paired devices"
            color: ThemeColor.fgMuted
            font.pixelSize: ThemeFont.xs
            Layout.leftMargin: 4
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeColor.borderBase
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            UiButton {
                Layout.fillWidth: true
                contentText: ThemeIcon.network + " Network settings"
                hasBorder: true
                pixelSize: ThemeFont.xs
                onClicked: {
                    Hyprland.dispatch("hl.dsp.exec_cmd(\"nm-connection-editor\")");
                    root.toggle();
                }
            }

            UiButton {
                Layout.fillWidth: true
                contentText: ThemeIcon.bluetooth + " Bluetooth settings"
                hasBorder: true
                pixelSize: ThemeFont.xs
                onClicked: {
                    Hyprland.dispatch("hl.dsp.exec_cmd(\"blueman-manager\")");
                    root.toggle();
                }
            }

        }

    }

}
