import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: root

    function getWindowIcon(client) {
        if (!client || !client.wayland || !client.wayland.appId)
            return ThemeIcons.defaultIcon;

        let appId = client.wayland.appId.toLowerCase();
        if (appId.includes("firefox") || appId.includes("zen"))
            return ThemeIcons.browser;

        if (appId.includes("youtube_music") || appId.includes("youtube-music"))
            return ThemeIcons.music;

        if (appId.includes("code") || appId.includes("codium"))
            return ThemeIcons.code;

        if (appId.includes("kitty"))
            return ThemeIcons.terminal;

        if (appId.includes("thunar") || appId.includes("dolphin"))
            return ThemeIcons.folder;

        if (appId.includes("discord"))
            return ThemeIcons.discord;

        if (appId.includes("vlc"))
            return ThemeIcons.media;

        if (appId.includes("nwg-look") || appId.includes("qt5ct") || appId.includes("qt6ct"))
            return ThemeIcons.settingsAlt;

        if (appId.includes("blueman-manager"))
            return ThemeIcons.bluetoothManager;

        if (appId.includes("pavucontrol"))
            return ThemeIcons.audioControl;

        if (appId.includes("nm-connection-editor"))
            return ThemeIcons.networkManager;

        if (appId.includes("superproductivity"))
            return ThemeIcons.productivity;

        if (appId.includes("thunderbird"))
            return ThemeIcons.thunderbird;

        if (appId.includes("mail"))
            return ThemeIcons.mail;

        return ThemeIcons.defaultIcon;
    }

    implicitWidth: wsRow.implicitWidth + 16
    implicitHeight: wsRow.implicitHeight + 16
    color: ThemeColors.bgBase
    radius: 8
    border.color: ThemeColors.borderBase
    border.width: 1

    RowLayout {
        id: wsRow

        anchors.centerIn: parent
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

            delegate: Item {
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
                implicitHeight: 24

                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: wsDelegate.isActive ? Qt.alpha(ThemeColors.accentPrimary, 0.15) : (wsMouse.containsMouse ? Qt.alpha(ThemeColors.fgPrimary, 0.08) : "transparent")

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }

                    }

                }

                Rectangle {
                    width: parent.width * 0.6
                    height: 2
                    radius: 1
                    color: ThemeColors.accentPrimary
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: wsDelegate.isActive
                }

                RowLayout {
                    id: wsContentLayout

                    anchors.centerIn: parent
                    spacing: 4

                    UiText {
                        text: wsDelegate.wsInfo.name
                        color: wsDelegate.isActive ? ThemeColors.accentPrimary : Qt.alpha(ThemeColors.fgPrimary, 0.6)
                        font.pixelSize: ThemeFonts.xs
                        font.bold: wsDelegate.isActive
                        Layout.alignment: Qt.AlignVCenter
                    }

                    RowLayout {
                        spacing: 3
                        visible: wsDelegate.workspaceClients.length > 0
                        Layout.alignment: Qt.AlignVCenter

                        Repeater {
                            model: wsDelegate.workspaceClients

                            delegate: UiText {
                                required property var modelData

                                text: root.getWindowIcon(modelData)
                                color: wsDelegate.isActive ? ThemeColors.accentPrimary : Qt.alpha(ThemeColors.fgPrimary, 0.5)
                                font.pixelSize: ThemeFonts.sm
                                Layout.alignment: Qt.AlignVCenter
                            }

                        }

                    }

                }

                MouseArea {
                    id: wsMouse

                    anchors.fill: parent
                    hoverEnabled: true
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
