import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell.Networking
import Quickshell.Wayland

PanelWindow {
    id: root

    required property real barHeight
    property bool opened: false
    property var wifiDevice: {
        for (let i = 0; i < Networking.devices.values.length; ++i) {
            const device = Networking.devices.values[i];
            if (device.type === DeviceType.Wifi)
                return device;

        }
        return null;
    }
    property var bluetoothAdapter: Bluetooth.defaultAdapter

    visible: opened
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    focusable: true

    // Full screen transparent surface.
    // This allows us to detect clicks outside the popup.
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    MouseArea {
        anchors.fill: parent
        z: 0
        onClicked: {
            root.opened = false;
        }
    }

    Process {
        id: nmProcess

        command: ["nm-connection-editor"]
    }

    Process {
        id: bluetoothProcess

        command: ["blueman-manager"]
    }

    Rectangle {
        id: popup

        z: 1
        width: 360
        height: content.implicitHeight + 28
        radius: 12
        color: ThemeColor.bgBase
        border.width: 1
        border.color: ThemeColor.borderBase

        anchors {
            top: parent.top
            right: parent.right
            topMargin: root.barHeight + 12
            rightMargin: 16
        }

        ColumnLayout {
            id: content

            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

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
                    color: closeMouse.containsMouse ? ThemeColor.bgSurfaceHover : "transparent"

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
                            root.opened = false;
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
                    color: modelData.connected ? ThemeColor.bgSurfaceActive : wifiMouse.containsMouse ? ThemeColor.bgSurfaceHover : ThemeColor.bgBase

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 10
                        spacing: 10

                        Text {
                            text: modelData.connected ? "󰖩" : "󱚵"
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
                            text: "✓"
                            color: ThemeColor.success
                            font.pixelSize: ThemeFont.sm
                            font.bold: true
                        }

                        Text {
                            visible: modelData.stateChanging
                            text: "…"
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
                    color: root.bluetoothAdapter && root.bluetoothAdapter.enabled ? ThemeColor.accentSecondary : ThemeColor.bgSurfaceHover
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
                    property bool busy: false

                    visible: modelData.paired
                    width: bluetoothList.width
                    height: visible ? 46 : 0
                    radius: 8
                    color: modelData.connected ? ThemeColor.bgSurfaceActive : bluetoothMouse.containsMouse ? ThemeColor.bgSurfaceHover : ThemeColor.bgBase

                    Connections {
                        function onConnectedChanged() {
                            busy = false;
                        }

                        target: modelData
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 10
                        spacing: 10

                        Text {
                            text: "󰂱"
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
                            text: busy || modelData.connecting ? "Loading…" : ""
                            color: ThemeColor.accentSecondary
                            font.pixelSize: ThemeFont.md
                        }

                        Text {
                            visible: !busy && !modelData.connecting
                            text: modelData.connected ? "✓" : "›"
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
                        enabled: !busy && !modelData.connecting
                        onClicked: {
                            if (busy)
                                return ;

                            busy = true;
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

                Rectangle {
                    Layout.fillWidth: true
                    height: 34
                    radius: 8
                    color: nmMouse.containsMouse ? ThemeColor.bgSurfaceHover : ThemeColor.bgBase
                    border.width: 1
                    border.color: ThemeColor.borderBase

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "󰛳"
                            color: ThemeColor.accentPrimary
                            font.pixelSize: ThemeFont.sm
                        }

                        Text {
                            text: "Network settings"
                            color: ThemeColor.fgPrimary
                            font.pixelSize: ThemeFont.xs
                        }

                    }

                    MouseArea {
                        id: nmMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            nmProcess.running = true;
                            root.opened = false;
                        }
                    }

                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 34
                    radius: 8
                    color: blueMouse.containsMouse ? ThemeColor.bgSurfaceHover : ThemeColor.bgBase
                    border.width: 1
                    border.color: ThemeColor.borderBase

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "󰂰"
                            color: ThemeColor.accentSecondary
                            font.pixelSize: ThemeFont.sm
                        }

                        Text {
                            text: "Bluetooth settings"
                            color: ThemeColor.fgPrimary
                            font.pixelSize: ThemeFont.xs
                        }

                    }

                    MouseArea {
                        id: blueMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            bluetoothProcess.running = true;
                            root.opened = false;
                        }
                    }

                }

            }

        }

    }

}
