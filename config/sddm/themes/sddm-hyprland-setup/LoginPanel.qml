import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Window

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
        color: Qt.alpha(ThemeColors.bgSurfaceDisabled, 0.55)
        border.color: Qt.alpha(ThemeColors.accentPrimary, 0.22)
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
        spacing: 8

        Item {
            id: avatarContainer

            width: 72
            height: 72
            anchors.horizontalCenter: parent.horizontalCenter

            // Fallback avatar background when image is missing or loading
            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: Qt.alpha(ThemeColors.bgBase, 0.8)
                border.color: Qt.alpha(ThemeColors.accentPrimary, 0.3)
                border.width: 1

                Text {
                    font.family: config.Font
                    anchors.centerIn: parent
                    text: (userInput.text.length > 0 ? userInput.text.charAt(0).toUpperCase() : "?")
                    font.pixelSize: 28
                    font.bold: true
                    color: ThemeColors.accentPrimary
                }

            }

            // Circular Avatar Container
            Item {
                anchors.fill: parent
                visible: avatarImage.status === Image.Ready

                Image {
                    id: avatarImage

                    anchors.fill: parent
                    source: userModel.data(userModel.index(userModel.lastIndex, 0), 260) || ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true
                    antialiasing: true
                    visible: false
                }

                // Smooth Circle Masking via MultiEffect
                MultiEffect {
                    anchors.fill: parent
                    source: avatarImage
                    maskEnabled: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1

                    maskSource: ShaderEffectSource {
                        smooth: true

                        sourceItem: Rectangle {
                            width: avatarContainer.width
                            height: avatarContainer.height
                            radius: width / 2
                            color: "black"
                            antialiasing: true
                        }

                    }

                }

            }

            // Accent border on top
            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                border.color: ThemeColors.accentPrimary
                border.width: 3
                antialiasing: true
            }

        }

        Item {
            height: 8
            width: 1
        }

        // Login field
        Rectangle {
            width: parent.width - 56
            anchors.horizontalCenter: parent.horizontalCenter
            height: 44
            radius: 8
            color: Qt.alpha(ThemeColors.bgBase, 0.5)
            border.color: Qt.alpha(ThemeColors.accentPrimary, 0.35)
            border.width: 1

            TextInput {
                id: userInput

                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                text: userModel.data(userModel.index(userModel.lastIndex, 0), 257) || ""
                font.pixelSize: 14
                font.family: config.Fonts
                color: ThemeColors.fgPrimary
                verticalAlignment: TextInput.AlignVCenter
                Keys.onReturnPressed: pwdInput.forceActiveFocus()
                Keys.onEnterPressed: pwdInput.forceActiveFocus()

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "username"
                    font: parent.font
                    color: Qt.alpha(ThemeColors.fgMuted, 0.45)
                    visible: parent.text === "" && !parent.activeFocus
                }

            }

        }

        // Password field
        Rectangle {
            width: parent.width - 56
            anchors.horizontalCenter: parent.horizontalCenter
            height: 44
            radius: 8
            color: Qt.alpha(ThemeColors.bgBase, 0.5)
            border.color: pwdInput.activeFocus ? Qt.alpha(ThemeColors.accentPrimary, 0.9) : Qt.alpha(ThemeColors.accentPrimary, 0.35)
            border.width: pwdInput.activeFocus ? 2 : 1

            Row {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 8

                TextInput {
                    id: pwdInput

                    width: parent.width
                    height: parent.height
                    echoMode: TextInput.Password
                    font.family: config.Font
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
                        color: Qt.alpha(ThemeColors.fgMuted, 0.45)
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
            height: 8
            width: 1
        }

        // Error message
        Text {
            id: errorMsg

            font.family: config.Font
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
            color: btnMouse.containsMouse ? Qt.alpha(ThemeColors.accentPrimary, 0.85) : Qt.alpha(ThemeColors.accentPrimary, 0.65)

            Text {
                anchors.centerIn: parent
                font.family: config.Font
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
        // Handle login failure signal from SDDM
        function onLoginFailed() {
            errorMsg.text = "incorrect credentials";
            pwdInput.text = "";
            pwdInput.forceActiveFocus();
        }

        target: sddm
    }

}
