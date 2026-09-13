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
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.lg
                font.bold: true
                Layout.fillWidth: true
            }

            UiButton {
                contentText: ThemeIcons.cross
                onClicked: {
                    root.toggle();
                }
            }

        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeColors.borderBase
        }

        Text {
            text: "Wi-Fi"
            color: ThemeColors.accentPrimary
            font.pixelSize: ThemeFonts.sm
            font.bold: true
        }

        Text {
            visible: root.wifiDevice === null
            text: "No Wi-Fi adapter"
            color: ThemeColors.fgMuted
            font.pixelSize: ThemeFonts.xs
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
                color: modelData.connected ? ThemeColors.bgSurfaceActive : ThemeColors.bgBase

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 10
                    spacing: 10

                    Text {
                        text: modelData.connected ? ThemeIcons.wifi : ThemeIcons.wifiOff
                        color: modelData.connected ? ThemeColors.accentPrimary : ThemeColors.fgMuted
                        font.pixelSize: ThemeFonts.lg
                    }

                    Text {
                        text: modelData.name
                        color: ThemeColors.fgPrimary
                        font.pixelSize: ThemeFonts.sm
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        visible: modelData.connected
                        text: ThemeIcons.check
                        color: ThemeColors.success
                        font.pixelSize: ThemeFonts.sm
                        font.bold: true
                    }

                    Text {
                        visible: modelData.stateChanging
                        text: "Loading…"
                        color: ThemeColors.accentPrimary
                        font.pixelSize: ThemeFonts.md
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
            color: ThemeColors.borderBase
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Bluetooth"
                color: ThemeColors.accentSecondary
                font.pixelSize: ThemeFonts.sm
                font.bold: true
                Layout.fillWidth: true
            }

            Rectangle {
                id: bluetoothToggle

                width: 42
                height: 24
                radius: 12
                color: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? ThemeColors.bgSurfaceActive : ThemeColors.bgSurfaceDisabled
                border.width: 1
                border.color: ThemeColors.borderBase

                Rectangle {
                    width: 18
                    height: 18
                    radius: 8
                    anchors.verticalCenter: parent.verticalCenter
                    x: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? parent.width - width - 3 : 3
                    color: ThemeColors.fgPrimary

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
                color: modelData.connected ? ThemeColors.bgSurfaceActive : bluetoothMouse.containsMouse ? ThemeColors.bgSurfaceActive : ThemeColors.bgBase

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
                        text: ThemeIcons.bluetoothConnect
                        color: modelData.connected ? ThemeColors.accentSecondary : ThemeColors.fgMuted
                        font.pixelSize: ThemeFonts.lg
                    }

                    Text {
                        text: modelData.name || "Unknown device"
                        color: ThemeColors.fgPrimary
                        font.pixelSize: ThemeFonts.sm
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: isBusy || modelData.connecting ? "Loading…" : ""
                        color: ThemeColors.accentSecondary
                        font.pixelSize: ThemeFonts.md
                    }

                    Text {
                        visible: !isBusy && !modelData.connecting
                        text: modelData.connected ? ThemeIcons.check : ThemeColors.chevronRight
                        color: modelData.connected ? ThemeColors.success : ThemeColors.fgMuted
                        font.pixelSize: ThemeFonts.md
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
            color: ThemeColors.fgMuted
            font.pixelSize: ThemeFonts.xs
            Layout.leftMargin: 4
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeColors.borderBase
            Layout.topMargin: 2
            Layout.bottomMargin: 2
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            UiButton {
                Layout.fillWidth: true
                contentText: "Network settings"
                hasBorder: true
                pixelSize: ThemeFonts.sm
                onClicked: {
                    Hyprland.dispatch("hl.dsp.exec_cmd(\"nm-connection-editor\")");
                    root.toggle();
                }
            }

            UiButton {
                Layout.fillWidth: true
                contentText: "Bluetooth settings"
                hasBorder: true
                pixelSize: ThemeFonts.sm
                onClicked: {
                    Hyprland.dispatch("hl.dsp.exec_cmd(\"blueman-manager\")");
                    root.toggle();
                }
            }

        }

    }

}
