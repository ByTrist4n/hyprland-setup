import "../../theme"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: root

    function getWindowIcon(client) {
        if (!client)
            return "";

        let appId = client.wayland.appId.toLowerCase();
        // Match rules2
        if (appId.includes("firefox") || appId.includes("zen"))
            return "";

        if (appId.includes("youtube_music") || appId.includes("youtube-music"))
            return "󰝚";

        if (appId.includes("code") || appId.includes("codium"))
            return "";

        if (appId.includes("kitty"))
            return "󰆍";

        if (appId.includes("thunar") || appId.includes("dolphin"))
            return "";

        if (appId.includes("discord"))
            return "";

        if (appId.includes("vlc"))
            return "󰕼";

        if (appId.includes("nwg-look") || appId.includes("qt5ct") || appId.includes("qt6ct"))
            return "󰒓";

        if (appId.includes("blueman-manager"))
            return "";

        if (appId.includes("pavucontrol"))
            return "󱕂";

        if (appId.includes("nm-connection-editor"))
            return "󰐻";

        if (appId.includes("superproductivity"))
            return "";

        return "";
    }

    implicitWidth: wsRow.implicitWidth + 16
    implicitHeight: wsRow.implicitHeight + 16
    color: ThemeColor.bgSurface
    radius: 8
    border.color: ThemeColor.borderBase
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        RowLayout {
            id: wsRow

            spacing: 4

            Repeater {
                model: {
                    let list = [{
                        "id": 1,
                        "name": "1"
                    }, {
                        "id": 2,
                        "name": "2"
                    }, {
                        "id": 3,
                        "name": "3"
                    }, {
                        "id": 4,
                        "name": "4"
                    }, {
                        "id": 5,
                        "name": "5"
                    }];
                    if (Hyprland.workspaces) {
                        for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                            let ws = Hyprland.workspaces.values[i];
                            if (ws.id > 5 || ws.id < 1)
                                list.push({
                                "id": ws.id,
                                "name": ws.name
                            });

                        }
                    }
                    return list;
                }

                delegate: Rectangle {
                    id: wsDelegate

                    required property var modelData
                    property var wsInfo: modelData
                    property bool isActive: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === wsInfo.id : false
                    // Filter toplevels for windows belonging to this workspace
                    property var workspaceClients: {
                        let clients = [];
                        if (Hyprland.toplevels) {
                            for (let i = 0; i < Hyprland.toplevels.values.length; i++) {
                                let top = Hyprland.toplevels.values[i];
                                if (top.workspace && top.workspace.id === wsInfo.id)
                                    clients.push(top);

                            }
                        }
                        return clients;
                    }

                    implicitWidth: wsContentLayout.implicitWidth + 12
                    implicitHeight: 22
                    radius: 4
                    color: isActive ? ThemeColor.bgSurfaceActive : "transparent"

                    RowLayout {
                        id: wsContentLayout

                        anchors.centerIn: parent
                        spacing: 3

                        Text {
                            text: wsDelegate.wsInfo.name
                            color: wsDelegate.isActive ? ThemeColor.accentPrimary : ThemeColor.fgPrimary
                            font.pixelSize: ThemeFont.sm
                            font.bold: wsDelegate.isActive
                            Layout.alignment: Qt.AlignVCenter
                        }

                        RowLayout {
                            spacing: 2
                            visible: wsDelegate.workspaceClients.length > 0
                            Layout.alignment: Qt.AlignBottom
                            Layout.bottomMargin: 2

                            Repeater {
                                model: wsDelegate.workspaceClients

                                delegate: Text {
                                    required property var modelData

                                    text: root.getWindowIcon(modelData)
                                    color: wsDelegate.isActive ? ThemeColor.accentPrimary : ThemeColor.fgPrimary
                                    font.pixelSize: ThemeFont.md
                                }

                            }

                        }

                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: (event) => {
                            if (wsDelegate.wsInfo.id > 0) {
                                Hyprland.dispatch(`hl.dsp.focus({ workspace = "${wsDelegate.wsInfo.id}" })`);
                            } else {
                                let cleanSpecialName = wsDelegate.wsInfo.name.replace("special:", "");
                                Hyprland.dispatch(`hl.dsp.workspace.toggle_special("${cleanSpecialName}")`);
                            }
                        }
                    }

                }

            }

        }

    }

}
