import "../../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Wayland

PanelWindow {
    id: root

    required property real barHeight
    required property bool isPrimaryScreen
    property bool opened: false
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: {
        if (!sink || !sink.audio)
            return 0;

        return Math.max(0, Math.min(1, sink.audio.volume));
    }
    readonly property bool muted: {
        if (!sink || !sink.audio)
            return false;

        return sink.audio.muted;
    }
    property bool sliderDragging: false

    function changeVolume(newVolume) {
        if (!root.sink || !root.sink.audio)
            return ;

        root.sink.audio.volume = Math.max(0, Math.min(1, Number(newVolume)));
    }

    function setVolumeFromPosition(x, width) {
        if (width <= 0)
            return ;

        const ratio = Math.max(0, Math.min(1, x / width));
        root.changeVolume(ratio);
    }

    function toggleMute() {
        if (!root.sink || !root.sink.audio)
            return ;

        root.sink.audio.muted = !root.sink.audio.muted;
    }

    visible: opened && isPrimaryScreen
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore
    focusable: false

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    margins {
        top: 0
        left: 0
        right: 0
        bottom: 0
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    MouseArea {
        id: outsideMouseArea

        anchors.fill: parent
        z: 0
        onClicked: {
            root.opened = false;
        }
    }

    Rectangle {
        id: popup

        z: 10
        width: 300
        height: content.implicitHeight + 32
        anchors.topMargin: root.barHeight + 8
        anchors.rightMargin: 12
        radius: 16
        color: ThemeColor.bgBase
        border.width: 1
        border.color: ThemeColor.borderBase

        anchors {
            top: parent.top
            right: parent.right
        }

        ColumnLayout {
            id: content

            anchors.margins: 16
            spacing: 14

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Volume"
                    color: ThemeColor.fgPrimary
                    font.pixelSize: ThemeFont.lg
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: "󰅖"
                    color: ThemeColor.fgMuted
                    font.pixelSize: ThemeFont.md

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.opened = false;
                        }
                    }

                }

            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: root.muted ? "Mute" : Math.round(root.volume * 100) + "%"
                    color: root.muted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
                    font.pixelSize: ThemeFont.md
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: root.muted ? "󰝟" : "󰕾"
                    color: root.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    font.pixelSize: ThemeFont.lg

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.toggleMute();
                        }
                    }

                }

            }

            Item {
                id: slider

                Layout.fillWidth: true
                implicitHeight: 32

                Rectangle {
                    id: track

                    x: 0
                    width: parent.width
                    height: 8
                    anchors.verticalCenter: parent.verticalCenter
                    radius: height / 2
                    color: ThemeColor.bgSurface
                }

                Rectangle {
                    id: fill

                    anchors.left: track.left
                    anchors.verticalCenter: track.verticalCenter
                    width: track.width * root.volume
                    height: track.height
                    radius: height / 2
                    color: root.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                }

                Rectangle {
                    id: handle

                    width: 18
                    height: 18
                    radius: 9
                    anchors.verticalCenter: track.verticalCenter
                    x: Math.max(0, Math.min(slider.width - width, root.volume * slider.width - width / 2))
                    color: root.muted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    border.width: 2
                    border.color: ThemeColor.bgBase
                }

                MouseArea {
                    id: sliderMouseArea

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    preventStealing: true
                    onPressed: (mouse) => {
                        root.sliderDragging = true;
                        root.setVolumeFromPosition(mouse.x, slider.width);
                    }
                    onPositionChanged: (mouse) => {
                        if (!pressed)
                            return ;

                        root.setVolumeFromPosition(mouse.x, slider.width);
                    }
                    onReleased: {
                        root.sliderDragging = false;
                    }
                    onCanceled: {
                        root.sliderDragging = false;
                    }
                    onWheel: (wheel) => {
                        const step = 0.02;
                        if (wheel.angleDelta.y > 0)
                            root.changeVolume(root.volume + step);
                        else if (wheel.angleDelta.y < 0)
                            root.changeVolume(root.volume - step);
                        wheel.accepted = true;
                    }
                }

            }

        }

    }

}
