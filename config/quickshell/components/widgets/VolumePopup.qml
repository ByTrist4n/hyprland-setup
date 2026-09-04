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
    property bool isOpened: false
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property real audioVolume: getVolume(sink)
    readonly property bool audioMuted: getMuted(sink)
    readonly property real micVolume: getVolume(source)
    readonly property bool micMuted: getMuted(source)
    property bool isSliderDragging: false
    property bool isMicSliderDragging: false

    function getVolume(node) {
        if (!node || !node.audio)
            return 0;

        return Math.max(0, Math.min(1, node.audio.volume));
    }

    function getMuted(node) {
        if (!node || !node.audio)
            return false;

        return node.audio.muted;
    }

    function setNodeVolume(node, newVolume) {
        if (!node || !node.audio)
            return ;

        node.audio.volume = Math.max(0, Math.min(1, Number(newVolume)));
    }

    function setNodeVolumeFromPosition(node, x, width) {
        if (width <= 0)
            return ;

        const ratio = Math.max(0, Math.min(1, x / width));
        root.setNodeVolume(node, ratio);
    }

    function toggleNodeMute(node) {
        if (!node || !node.audio)
            return ;

        node.audio.muted = !node.audio.muted;
    }

    visible: isOpened && isPrimaryScreen
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
        objects: {
            let list = [];
            if (root.sink)
                list.push(root.sink);

            if (root.source)
                list.push(root.source);

            return list;
        }
    }

    MouseArea {
        id: outsideMouseArea

        anchors.fill: parent
        z: 0
        onClicked: {
            root.isOpened = false;
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
            spacing: 16

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Audio Controls"
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
                            root.isOpened = false;
                        }
                    }

                }

            }

            // ==================== AUDIO OUTPUT ====================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Volume"
                        color: ThemeColor.fgMuted
                        font.pixelSize: ThemeFont.sm
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.audioMuted ? "Mute" : Math.round(root.audioVolume * 100) + "%"
                        color: root.audioMuted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.md
                        font.bold: true
                    }

                    Text {
                        text: root.audioMuted ? "󰝟" : "󰕾"
                        color: root.audioMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                        font.pixelSize: ThemeFont.lg

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.toggleNodeMute(root.sink);
                            }
                        }

                    }

                }

                Item {
                    id: slider

                    Layout.fillWidth: true
                    implicitHeight: 24

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
                        width: track.width * root.audioVolume
                        height: track.height
                        radius: height / 2
                        color: root.audioMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    }

                    Rectangle {
                        id: handle

                        width: 18
                        height: 18
                        radius: 9
                        anchors.verticalCenter: track.verticalCenter
                        x: Math.max(0, Math.min(slider.width - width, root.audioVolume * slider.width - width / 2))
                        color: root.audioMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
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
                            root.isSliderDragging = true;
                            root.setNodeVolumeFromPosition(root.sink, mouse.x, slider.width);
                        }
                        onPositionChanged: (mouse) => {
                            if (!pressed)
                                return ;

                            root.setNodeVolumeFromPosition(root.sink, mouse.x, slider.width);
                        }
                        onReleased: {
                            root.isSliderDragging = false;
                        }
                        onCanceled: {
                            root.isSliderDragging = false;
                        }
                        onWheel: (wheel) => {
                            const step = 0.02;
                            if (wheel.angleDelta.y > 0)
                                root.setNodeVolume(root.sink, root.audioVolume + step);
                            else if (wheel.angleDelta.y < 0)
                                root.setNodeVolume(root.sink, root.audioVolume - step);
                            wheel.accepted = true;
                        }
                    }

                }

            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: ThemeColor.borderBase
                opacity: 0.5
            }

            // ==================== MICROPHONE ====================
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Microphone"
                        color: ThemeColor.fgMuted
                        font.pixelSize: ThemeFont.sm
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Text {
                        text: root.micMuted ? "Mute" : Math.round(root.micVolume * 100) + "%"
                        color: root.micMuted ? ThemeColor.fgMuted : ThemeColor.fgPrimary
                        font.pixelSize: ThemeFont.md
                        font.bold: true
                    }

                    Text {
                        text: root.micMuted ? "󰍭" : "󰍬"
                        color: root.micMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                        font.pixelSize: ThemeFont.lg

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.toggleNodeMute(root.source);
                            }
                        }

                    }

                }

                Item {
                    id: micSlider

                    Layout.fillWidth: true
                    implicitHeight: 24

                    Rectangle {
                        id: micTrack

                        x: 0
                        width: parent.width
                        height: 8
                        anchors.verticalCenter: parent.verticalCenter
                        radius: height / 2
                        color: ThemeColor.bgSurface
                    }

                    Rectangle {
                        id: micFill

                        anchors.left: micTrack.left
                        anchors.verticalCenter: micTrack.verticalCenter
                        width: micTrack.width * root.micVolume
                        height: micTrack.height
                        radius: height / 2
                        color: root.micMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                    }

                    Rectangle {
                        id: micHandle

                        width: 18
                        height: 18
                        radius: 9
                        anchors.verticalCenter: micTrack.verticalCenter
                        x: Math.max(0, Math.min(micSlider.width - width, root.micVolume * micSlider.width - width / 2))
                        color: root.micMuted ? ThemeColor.fgMuted : ThemeColor.accentPrimary
                        border.width: 2
                        border.color: ThemeColor.bgBase
                    }

                    MouseArea {
                        id: micSliderMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        preventStealing: true
                        onPressed: (mouse) => {
                            root.isMicSliderDragging = true;
                            root.setNodeVolumeFromPosition(root.source, mouse.x, micSlider.width);
                        }
                        onPositionChanged: (mouse) => {
                            if (!pressed)
                                return ;

                            root.setNodeVolumeFromPosition(root.source, mouse.x, micSlider.width);
                        }
                        onReleased: {
                            root.isMicSliderDragging = false;
                        }
                        onCanceled: {
                            root.isMicSliderDragging = false;
                        }
                        onWheel: (wheel) => {
                            const step = 0.02;
                            if (wheel.angleDelta.y > 0)
                                root.setNodeVolume(root.source, root.micVolume + step);
                            else if (wheel.angleDelta.y < 0)
                                root.setNodeVolume(root.source, root.micVolume - step);
                            wheel.accepted = true;
                        }
                    }

                }

            }

        }

    }

}
