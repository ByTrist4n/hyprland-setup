import QtQuick

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

            font.family: config.fontFamily
            font.pixelSize: 96
            font.bold: true
            color: ThemeColors.fgPrimary
        }

        Rectangle {
            width: timeText.contentWidth
            height: 2
            radius: 1
            color: ThemeColors.fgMuted

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

        // Date
        Text {
            id: dateText

            font.family: config.fontFamily
            font.pixelSize: 18
            color: ThemeColors.fgPrimary
        }

    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date();
            var hours = Qt.formatTime(now, "HH");
            var minutes = Qt.formatTime(now, "mm");
            timeText.text = "<font color='" + ThemeColors.accentPrimary + "'>" + hours + "</font>:" + minutes;
            dateText.text = now.toLocaleDateString(Qt.locale("en_US"), "dddd, MMMM d, yyyy");
            secBar.width = timeText.contentWidth * (now.getSeconds() / 60);
        }
    }

}
