import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: button

    required property var notificationManager
    required property var notificationCenter

    implicitWidth: 36
    implicitHeight: 36
    radius: 8
    color: notificationMouseArea.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgBase
    border.width: 1
    border.color: ThemeColors.borderBase

    UiText {
        anchors.centerIn: parent
        // TODO: Do not disturb mode
        text: false ? ThemeIcons.notificationOff : ThemeIcons.notification
        color: notificationManager.notifications.length > 0 ? ThemeColors.accentPrimary : ThemeColors.fgPrimary
        font.pixelSize: ThemeFonts.lg

        Behavior on color {
            ColorAnimation {
                duration: 150
            }

        }

    }

    Rectangle {
        visible: notificationManager.notifications.length > 0
        width: notificationManager.notifications.length > 9 ? 18 : 16
        height: width
        radius: width / 2
        color: ThemeColors.accentPrimary

        anchors {
            top: parent.top
            right: parent.right
            topMargin: -2
            rightMargin: -2
        }

        UiText {
            anchors.centerIn: parent
            text: notificationManager.notifications.length > 99 ? "99+" : notificationManager.notifications.length
            color: ThemeColors.bgBase
            font.pixelSize: ThemeFonts.xs
            font.bold: true
        }

    }

    MouseArea {
        id: notificationMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            notificationCenter.toggle();
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 120
        }

    }

    Behavior on border.width {
        NumberAnimation {
            duration: 100
        }

    }

}
