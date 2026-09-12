import QtQuick 2.15
import SddmComponents 2.0

Item {
    id: root

    function doLogin() {
        if (pwdInput.text === "")
            return ;

        errorMsg.text = "";
        sddm.login(userInput.text, pwdInput.text, 0);
    }

    width: 340
    height: col.implicitHeight + 56

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(ThemeColors.bgSurfaceDisabled.r, ThemeColors.bgSurfaceDisabled.g, ThemeColors.bgSurfaceDisabled.b, 0.55)
        border.color: Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.22)
        border.width: 1
        radius: 12

        Rectangle {
            width: parent.width * 0.4
            height: 2
            radius: 1
            color: ThemeColors.accentPrimary
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }

    }

    Column {
        id: col

        width: parent.width
        anchors.centerIn: parent
        spacing: 0

        // Login field
        Rectangle {
            width: parent.width - 56
            anchors.horizontalCenter: parent.horizontalCenter
            height: 44
            radius: 8
            color: Qt.rgba(ThemeColors.bgBase.r, ThemeColors.bgBase.g, ThemeColors.bgBase.b, 0.5)
            border.color: Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.35)
            border.width: 1

            TextInput {
                id: userInput

                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                text: userModel.data(userModel.index(userModel.lastIndex, 0), 257) || ""
                font.pixelSize: 14
                color: ThemeColors.fgPrimary
                verticalAlignment: TextInput.AlignVCenter
                Keys.onReturnPressed: pwdInput.forceActiveFocus()
                Keys.onEnterPressed: pwdInput.forceActiveFocus()

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "username"
                    font: parent.font
                    color: Qt.rgba(ThemeColors.fgMuted.r, ThemeColors.fgMuted.g, ThemeColors.fgMuted.b, 0.45)
                    visible: parent.text === "" && !parent.activeFocus
                }

            }

        }

        Item {
            height: 10
            width: 1
        }

        // Password field
        Rectangle {
            width: parent.width - 56
            anchors.horizontalCenter: parent.horizontalCenter
            height: 44
            radius: 8
            color: Qt.rgba(ThemeColors.bgBase.r, ThemeColors.bgBase.g, ThemeColors.bgBase.b, 0.5)
            border.color: pwdInput.activeFocus ? Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.9) : Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.35)
            border.width: pwdInput.activeFocus ? 2 : 1

            Row {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 8

                Text {
                    text: ""
                    font.pixelSize: 16
                    color: Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.7)
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextInput {
                    id: pwdInput

                    width: parent.width - 30
                    height: parent.height
                    echoMode: TextInput.Password
                    font.pixelSize: 14
                    color: ThemeColors.fgPrimary
                    verticalAlignment: TextInput.AlignVCenter
                    Keys.onReturnPressed: doLogin()
                    Keys.onEnterPressed: doLogin()
                    Component.onCompleted: forceActiveFocus()

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "password"
                        font: parent.font
                        color: Qt.rgba(ThemeColors.fgMuted.r, ThemeColors.fgMuted.g, ThemeColors.fgMuted.b, 0.45)
                        visible: parent.text === "" && !parent.activeFocus
                    }

                }

            }

            Behavior on border.color {
                ColorAnimation {
                    duration: 150
                }

            }

        }

        Item {
            height: 10
            width: 1
        }

        // Error message
        Text {
            id: errorMsg

            width: parent.width
            text: ""
            color: ThemeColors.urgent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            visible: "" !== text
        }

        Item {
            height: errorMsg.visible ? 8 : 0
            width: 1
        }

        // Login button
        Rectangle {
            width: parent.width - 56
            anchors.horizontalCenter: parent.horizontalCenter
            height: 44
            radius: 8
            color: btnMouse.containsMouse ? Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.85) : Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.65)

            Text {
                anchors.centerIn: parent
                text: "login"
                font.pixelSize: 14
                color: ThemeColors.fgOnAccent
            }

            MouseArea {
                id: btnMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: doLogin()
            }

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }

            }

        }

    }

    Connections {
        function onLoginFailed() {
            errorMsg.text = "incorrect credentials";
            pwdInput.text = "";
            pwdInput.forceActiveFocus();
        }

        target: sddm
    }

}
