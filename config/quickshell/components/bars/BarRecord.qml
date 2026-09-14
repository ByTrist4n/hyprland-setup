import "../../services"
import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root

    readonly property bool isRecording: CaptureService.isRecording
    readonly property bool isSharing: CaptureService.isSharing
    readonly property bool isMicActive: CaptureService.isMicActive

    visible: isRecording || isSharing || isMicActive
    implicitWidth: recordLayout.implicitWidth + 16
    implicitHeight: 32
    color: isRecording ? Qt.rgba(ThemeColors.urgent.r, ThemeColors.urgent.g, ThemeColors.urgent.b, 0.2) : (isSharing ? Qt.rgba(ThemeColors.warning.r, ThemeColors.warning.g, ThemeColors.warning.b, 0.2) : Qt.rgba(ThemeColors.accentPrimary.r, ThemeColors.accentPrimary.g, ThemeColors.accentPrimary.b, 0.2))
    radius: 8
    border.width: 1
    border.color: isRecording ? ThemeColors.urgent : (isSharing ? ThemeColors.warning : ThemeColors.accentPrimary)

    RowLayout {
        id: recordLayout

        anchors.centerIn: parent
        spacing: 6

        // Animated status indicator dot
        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: isRecording ? ThemeColors.urgent : (isSharing ? ThemeColors.warning : ThemeColors.accentPrimary)

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: root.visible

                PropertyAnimation {
                    to: 0.2
                    duration: 800
                }

                PropertyAnimation {
                    to: 1
                    duration: 800
                }

            }

        }

        // Dynamic labels according to active inputs
        Text {
            text: {
                let labels = [];
                if (isRecording)
                    labels.push("REC");

                if (isSharing)
                    labels.push("LIVE");

                if (isMicActive)
                    labels.push("MIC");

                return labels.join(" & ");
            }
            color: isRecording ? ThemeColors.urgent : (isSharing ? ThemeColors.warning : ThemeColors.accentPrimary)
            font.pixelSize: 12
            font.bold: true
        }

    }

}
