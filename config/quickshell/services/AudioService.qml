import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
pragma Singleton

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property real volume: (sink && sink.audio) ? Math.max(0, Math.min(1, sink.audio.volume)) : 0
    readonly property bool muted: (sink && sink.audio) ? Boolean(sink.audio.muted) : false
    readonly property real micVolume: (source && source.audio) ? Math.max(0, Math.min(1, source.audio.volume)) : 0
    readonly property bool micMuted: (source && source.audio) ? Boolean(source.audio.muted) : false

    function setVolume(newVolume) {
        if (sink && sink.audio)
            sink.audio.volume = Math.max(0, Math.min(1, Number(newVolume)));

    }

    function setMicVolume(newVolume) {
        if (source && source.audio)
            source.audio.volume = Math.max(0, Math.min(1, Number(newVolume)));

    }

    function toggleMute() {
        if (sink && sink.audio)
            sink.audio.muted = !sink.audio.muted;

    }

    function toggleMicMute() {
        if (source && source.audio)
            source.audio.muted = !source.audio.muted;

    }

    // Force node tracking to register audio property change listeners
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

}
