import "../../services"
import "../../theme"
import "../ui"
import "../widgets"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    implicitWidth: musicRow.implicitWidth + 16
    implicitHeight: 40
    color: musicMouseArea.containsMouse ? ThemeColors.bgButtonHover : ThemeColors.bgBase
    radius: 8
    border.color: ThemeColors.borderBase
    border.width: 1
    visible: MediaService.hasMedia

    RowLayout {
        id: musicRow

        anchors.centerIn: parent
        spacing: 12

        // Album cover thumbnail or fallback icon
        Rectangle {
            Layout.preferredWidth: 22
            Layout.preferredHeight: 22
            radius: 4
            color: ThemeColors.bgSurfaceActive
            clip: true

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: MediaService.trackArtUrl || ""
                visible: MediaService.trackArtUrl !== ""
                layer.enabled: true

                layer.effect: OpacityMask {

                    maskSource: Rectangle {
                        width: 22
                        height: 22
                        radius: 4
                    }

                }

            }

            UiText {
                anchors.centerIn: parent
                text: MediaService.isPlaying ? ThemeIcons.music : ThemeIcons.musicOff
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.xs
                visible: MediaService.trackArtUrl === ""
            }

        }

        RowLayout {
            spacing: 6

            UiText {
                text: MediaService.trackTitle || "Unknown title"
                Layout.maximumWidth: 180
                color: ThemeColors.fgPrimary
                font.pixelSize: ThemeFonts.sm
                font.bold: true
                elide: Text.ElideRight
            }

            UiText {
                text: "• " + (MediaService.trackArtist || "Unknown artist")
                Layout.maximumWidth: 120
                color: ThemeColors.fgMuted
                font.pixelSize: ThemeFonts.xs
                elide: Text.ElideRight
            }

        }

        CavaVisualizer {
            Layout.preferredWidth: 90
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter
        }

    }

    MouseArea {
        id: musicMouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.MiddleButton)
                MediaService.togglePlaying();
            else
                musicPopup.isOpened = !musicPopup.isOpened;
        }
        onWheel: (wheel) => {
            wheel.accepted = true;
            if (wheel.angleDelta.y < 0)
                MediaService.next();
            else
                MediaService.previous();
        }
    }

}
