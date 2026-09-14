import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Item {
    id: root

    property bool isRecording: false
    property bool isSharing: false
    property bool isMicActive: false

    // Process monitoring wf-recorder, PipeWire video streams, and ALSA mic streams
    Process {
        id: checkProcess

        command: ["sh", "-c", "while true; do \
            REC=$(pgrep -x wf-recorder > /dev/null && echo 'true' || echo 'false'); \
            SHARE=$(pw-dump | grep -q 'Video/Source' && echo 'true' || echo 'false'); \
            MIC=$( (fuser /dev/snd/pcm*c >/dev/null 2>&1 || pw-cli list-objects Node | grep -A 15 'media.class = \"Stream/Input/Audio\"' | grep -q 'state: \"running\"') && echo 'true' || echo 'false'); \
            echo \"$REC:$SHARE:$MIC\"; \
            sleep 1; \
        done"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                const parts = data.trim().split(":");
                if (parts.length === 3) {
                    root.isRecording = (parts[0] === "true");
                    root.isSharing = (parts[1] === "true");
                    root.isMicActive = (parts[2] === "true");
                }
            }
        }

    }

}
