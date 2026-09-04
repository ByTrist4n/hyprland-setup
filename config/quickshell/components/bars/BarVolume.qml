import "../../theme"
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var volumePopup

    implicitWidth: volumeRow.implicitWidth + 24
    implicitHeight: volumeRow.implicitHeight + 16
    radius: 10
    color: volumeMouseArea.containsMouse ? ThemeColor.bgSurfaceHover : ThemeColor.bgSurface
    border.width: 1
    border.color: ThemeColor.borderBase

    RowLayout {
        id: volumeRow

        anchors.centerIn: parent
        spacing: 6

        Text {
            text: {
                if (root.volumePopup.audioMuted)
                    return "󰝟";

                const volume = root.volumePopup.audioVolume;
                if (volume <= 0)
                    return "󰕿";

                if (volume < 0.5)
                    return "󰖀";

                return "󰕾";
            }
            color: root.volumePopup.audioMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
            font.pixelSize: ThemeFont.lg
        }

        Text {
            text: root.volumePopup.audioMuted ? "Mute" : Math.round(root.volumePopup.audioVolume * 100) + "%"
            color: root.volumePopup.audioMuted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
            font.pixelSize: ThemeFont.sm
            font.bold: true
        }

        Text {
            text: "| 󰍭  Mute"
            color: root.volumePopup.audioMuted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
            font.pixelSize: ThemeFont.sm
            font.bold: true
            visible: root.volumePopup.micMuted
        }

    }

    MouseArea {
        id: volumeMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button == Qt.RightButton)
                root.volumePopup.toggleNodeMute(volumePopup.sink);
            else
                root.volumePopup.isOpened = !root.volumePopup.isOpened;
        }
        onWheel: (wheel) => {
            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.volumePopup.setNodeVolume(volumePopup.sink, root.volumePopup.audioVolume + delta);
        }
    }

}
