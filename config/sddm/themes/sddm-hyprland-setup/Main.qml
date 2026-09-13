import QtQuick
import QtQuick.Controls
import QtQuick.Window

Rectangle {
    id: root

    width: Screen.width
    height: Screen.height
    color: ThemeColors.bgBase

    Image {
        anchors.fill: parent
        source: config.background || ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true

        Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.5
        }

    }

    Rectangle {
        anchors.fill: parent

        gradient: Gradient {
            orientation: Gradient.Vertical

            GradientStop {
                position: 0
                color: Qt.alpha(ThemeColors.bgBase, 0.45)
            }

            GradientStop {
                position: 1
                color: Qt.alpha(ThemeColors.bgBase, 0.75)
            }

        }

    }

    // Clock + Date (left)
    ClockWidget {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 96
    }

    // Login panel (center)
    LoginPanel {
        anchors.centerIn: parent
    }

    // Hostname (bottom-left)
    Text {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 36
        text: sddm.hostName
        font.pixelSize: 13
        color: ThemeColors.fgMuted
        opacity: 0.7
    }

}
