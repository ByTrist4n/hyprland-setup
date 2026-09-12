import QtQuick 2.15

Item {
    id: root

    width: col.implicitWidth
    height: col.implicitHeight

    Column {
        id: col

        spacing: 8

        // HH:mm
        Text {
            id: timeText

            font.pixelSize: 96
            font.weight: Font.Light
            color: ThemeColors.fgPrimary
        }

        Rectangle {
            width: timeText.contentWidth
            height: 2
            radius: 1
            color: Qt.rgba(ThemeColors.fgMuted.r, ThemeColors.fgMuted.g, ThemeColors.fgMuted.b, 0.25)

            Rectangle {
                id: secBar

                height: 2
                radius: 1
                color: ThemeColors.accentPrimary
            }

        }

        Item {
            height: 6
            width: 1
        }

        // date
        Text {
            id: dateText

            font.pixelSize: 18
            font.letterSpacing: 1
            color: ThemeColors.fgMuted
            opacity: 0.85
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            timeText.text = Qt.formatTime(now, "HH:mm");
            dateText.text = Qt.formatDate(now, "dddd MMMM d, yyyy");
            secBar.width = timeText.contentWidth * (now.getSeconds() / 60);
        }
    }

}
