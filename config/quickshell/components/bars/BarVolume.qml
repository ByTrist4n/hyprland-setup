import "../../services"
import "../../theme"
import "../ui"
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    required property var volumePopup

    implicitWidth: volumeRow.implicitWidth + 24
    implicitHeight: volumeRow.implicitHeight + 16
    radius: 8
    color: volumeMouseArea.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgBase
    border.width: 1
    border.color: ThemeColors.borderBase

    RowLayout {
        id: volumeRow

        anchors.centerIn: parent
        spacing: 6

        UiText {
            text: {
                if (AudioService.muted)
                    return ThemeIcons.volumeOff;

                const volume = AudioService.volume;
                if (volume <= 0)
                    return ThemeIcons.volumeLow;

                if (volume < 0.5)
                    return ThemeIcons.volumeMedium;

                return ThemeIcons.volume;
            }
            color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.accentPrimary
            font.pixelSize: ThemeFonts.lg
        }

        UiText {
            text: AudioService.muted ? "Mute" : Math.round(AudioService.volume * 100) + "%"
            color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.fgPrimary
            font.pixelSize: ThemeFonts.sm
            font.bold: true
        }

        UiText {
            text: "| 󰍭  Mute"
            color: AudioService.muted ? ThemeColors.fgMuted : ThemeColors.fgPrimary
            font.pixelSize: ThemeFonts.sm
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
