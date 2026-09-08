import "../../services"
import "../../theme"
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var volumePopup

    implicitWidth: volumeRow.implicitWidth + 24
    implicitHeight: volumeRow.implicitHeight + 16
    radius: 10
    color: volumeMouseArea.containsMouse ? ThemeColor.bgSurfaceActive : ThemeColor.bgSurface
    border.width: 1
    border.color: ThemeColor.borderBase

    RowLayout {
        id: volumeRow

        anchors.centerIn: parent
        spacing: 6

        Text {
            text: {
                if (AudioService.muted)
                    return ThemeIcon.volumeOff;

                const volume = AudioService.volume;
                if (volume <= 0)
                    return ThemeIcon.volumeLow;

                if (volume < 0.5)
                    return ThemeIcon.volumeMedium;

                return ThemeIcon.volume;
            }
            color: AudioService.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
            font.pixelSize: ThemeFont.lg
        }

        Text {
            text: AudioService.muted ? "Mute" : Math.round(AudioService.volume * 100) + "%"
            color: AudioService.muted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
            font.pixelSize: ThemeFont.sm
            font.bold: true
        }

        Text {
            text: "| 󰍭  Mute"
            color: AudioService.muted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
            font.pixelSize: ThemeFont.sm
            font.bold: true
            visible: AudioService.micMuted
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
                AudioService.toggleMute();
            else
                volumePopup.toggle();
        }
    }

}
