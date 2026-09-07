import "../../theme"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property real barHeight
    required property bool isPrimaryScreen
    property bool isOpened: false
    property real widgetX: 0
    property real widgetWidth: 0

    visible: isOpened && isPrimaryScreen
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    focusable: true

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    MouseArea {
        anchors.fill: parent
        z: 0
        onClicked: {
            root.isOpened = false;
        }
    }

    Rectangle {
        id: calendarFrame

        implicitWidth: mainLayout.implicitWidth + 24
        implicitHeight: mainLayout.implicitHeight + 24
        color: ThemeColor.bgBase
        border.color: ThemeColor.borderBase
        border.width: 1
        radius: 8
        x: Math.max(16, root.widgetX + (root.widgetWidth / 2) - (width / 2))
        y: root.barHeight
        z: 1

        ColumnLayout {
            id: mainLayout

            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDateTime(new Date(), "MMMM yyyy")
                color: ThemeColor.fgPrimary
                font.bold: true
            }

            GridView {
                implicitWidth: 210
                implicitHeight: cellHeight * Math.ceil(count / 7)
                cellWidth: 30
                cellHeight: 30
                model: {
                    var now = new Date();
                    var totalDays = new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate();
                    var firstDay = new Date(now.getFullYear(), now.getMonth(), 1).getDay();
                    var offset = (firstDay === 0) ? 6 : firstDay - 1; // Alignement Lundi
                    var days = [];
                    for (var i = 0; i < offset; i++) days.push("")
                    for (var d = 1; d <= totalDays; d++) days.push(d)
                    return days;
                }

                delegate: Item {
                    width: 30
                    height: 30

                    Rectangle {
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        radius: 4
                        color: modelData === new Date().getDate() ? ThemeColor.urgent : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: modelData === new Date().getDate() ? ThemeColor.fgOnAccent : ThemeColor.fgPrimary
                            font.bold: modelData === new Date().getDate()
                        }

                    }

                }

            }

        }

    }

}
