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
                if (root.volumePopup.muted)
                    return "󰝟";

                const volume = root.volumePopup.volume;
                if (volume <= 0)
                    return "󰕿";

                if (volume < 0.5)
                    return "󰖀";

                return "󰕾";
            }
            color: root.volumePopup.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
            font.pixelSize: ThemeFont.lg
        }

        Text {
            text: root.volumePopup.muted ? "Mute" : Math.round(root.volumePopup.volume * 100) + "%"
            color: root.volumePopup.muted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
            font.pixelSize: ThemeFont.sm
            font.bold: true
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
                root.volumePopup.toggleMute();
            else
                root.volumePopup.isOpened = !root.volumePopup.isOpened;
        }
        onWheel: (wheel) => {
            const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
            root.volumePopup.changeVolume(root.volumePopup.volume + delta);
        }
    }

}
