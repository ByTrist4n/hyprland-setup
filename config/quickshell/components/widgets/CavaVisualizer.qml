import "../../theme"
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property var barValues: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    implicitWidth: 160
    implicitHeight: 35

    Process {
        id: cavaProcess

        command: ["stdbuf", "-oL", "/usr/bin/cava", "-p", `${Quickshell.env("HOME")}/.config/cava/quickshell_config`]
        running: true

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (data) => {
                if (!data)
                    return ;

                const clean = data.trim();
                if (clean.length === 0)
                    return ;

                const parts = clean.split(";");
                if (parts.length >= 10) {
                    const newVals = [];
                    for (let i = 0; i < 10; i++) {
                        newVals.push(parseInt(parts[i], 10) || 0);
                    }
                    root.barValues = newVals;
                }
            }
        }

    }

    // Canvas background container to isolate geometry from parent layouts
    Item {
        anchors.fill: parent

        Repeater {
            model: 10

            Rectangle {
                // Calculate position x for each bar
                x: index * (parent.width / 10)
                width: (parent.width / 10) - 2
                // Anchor to bottom so heights grow upwards
                anchors.bottom: parent.bottom
                // Reactive height calculation
                height: Math.max(3, ((root.barValues[index] || 0) / 100) * parent.height)
                color: ThemeColor.accentPrimary
                radius: 2

                Behavior on height {
                    NumberAnimation {
                        duration: 25
                    }

                }

            }

        }

    }

}
