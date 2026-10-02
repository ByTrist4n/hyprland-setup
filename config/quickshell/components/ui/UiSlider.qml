import "../../theme"
import QtQuick
import QtQuick.Layouts

Item {
    id: sliderRoot

    property real value: 0
    property real step: 0.02
    property bool enabled: true
    property color activeColor: ThemeColors.accentPrimary
    property color inactiveColor: ThemeColors.fgMuted

    signal valueChangedRequested(real newValue)

    Layout.fillWidth: true
    implicitHeight: 24

    // Track background
    Rectangle {
        id: track

        x: 0
        width: parent.width
        height: 8
        anchors.verticalCenter: parent.verticalCenter
        radius: height / 2
        color: ThemeColors.bgSurfaceActive
    }

    // Active progress bar
    Rectangle {
        anchors.left: track.left
        anchors.verticalCenter: track.verticalCenter
        width: track.width * Math.max(0, Math.min(1, sliderRoot.value))
        height: track.height
        radius: height / 2
        color: sliderRoot.enabled ? sliderRoot.activeColor : sliderRoot.inactiveColor
    }

    // Handle dot
    Rectangle {
        width: 18
        height: 18
        radius: 9
        anchors.verticalCenter: track.verticalCenter
        x: Math.max(0, Math.min(sliderRoot.width - width, (sliderRoot.value * sliderRoot.width) - (width / 2)))
        color: sliderRoot.enabled ? sliderRoot.activeColor : sliderRoot.inactiveColor
        border.width: 2
        border.color: ThemeColors.bgBase
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        preventStealing: true
        onPressed: (mouse) => {
            sliderRoot.valueChangedRequested(mouse.x / sliderRoot.width);
        }
        onPositionChanged: (mouse) => {
            if (pressed)
                sliderRoot.valueChangedRequested(mouse.x / sliderRoot.width);

        }
        onWheel: (wheel) => {
            const delta = wheel.angleDelta.y > 0 ? sliderRoot.step : -sliderRoot.step;
            sliderRoot.valueChangedRequested(sliderRoot.value + delta);
            wheel.accepted = true;
        }
    }

}
