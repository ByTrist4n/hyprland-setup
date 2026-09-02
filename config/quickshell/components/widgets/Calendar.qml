import "../../theme"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: calendarPopup

    property Item targetItem

    function toggle() {
        visible = !visible;
    }

    anchor.item: targetItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    visible: false
    color: "transparent"
    implicitWidth: calendarFrame.implicitWidth
    implicitHeight: calendarFrame.implicitHeight

    Rectangle {
        id: calendarFrame

        implicitWidth: mainLayout.implicitWidth + 24
        implicitHeight: mainLayout.implicitHeight + 24
        color: ThemeColor.bgBase
        border.color: ThemeColor.borderBase
        border.width: 1
        radius: 8

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
