import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    property FileView colorsFile
    property var walColors: null
    property var walSpecial: null
    // --- 1. SURFACES & BACKGROUNDS ---
    readonly property color bgBase: getColor(walSpecial ? walSpecial.background : null, "#11111b")
    readonly property color bgSurface: getColor(walColors ? walColors.color0 : null, "#181825")
    readonly property color bgSurfaceHover: getColor(walColors ? walColors.color8 : null, "#313244")
    readonly property color bgSurfaceActive: getColor(walColors ? walColors.color8 : null, "#45475a")
    // --- 2. BORDERS ---
    readonly property color borderBase: getColor(walColors ? walColors.color8 : null, "#313244")
    readonly property color borderActive: getColor(walColors ? walColors.color4 : null, "#89b4fa")
    // --- 3. TEXT & ICONS ---
    readonly property color fgPrimary: getColor(walSpecial ? walSpecial.foreground : null, "#cdd6f4")
    readonly property color fgMuted: getColor(walColors ? walColors.color7 : null, "#a6adc8")
    readonly property color fgOnAccent: getColor(walSpecial ? walSpecial.background : null, "#11111b")
    // --- 4. ACCENTS & STATES ---
    readonly property color accentPrimary: getColor(walColors ? walColors.color4 : null, "#89b4fa")
    readonly property color accentSecondary: getColor(walColors ? walColors.color5 : null, "#cba6f7")
    readonly property color urgent: getColor(walColors ? walColors.color1 : null, "#f38ba8")
    readonly property color success: getColor(walColors ? walColors.color2 : null, "#a6e3a1")
    readonly property color warning: getColor(walColors ? walColors.color3 : null, "#f9e2af")

    function getColor(walProp, fallback) {
        return walProp ? walProp : fallback;
    }

    colorsFile: FileView {
        path: Quickshell.env("HOME") + "/.cache/wal/colors.json"
        onLoaded: {
            try {
                const parsed = JSON.parse(text());
                if (parsed && parsed.colors && parsed.special) {
                    root.walColors = parsed.colors;
                    root.walSpecial = parsed.special;
                }
            } catch (e) {
                console.log("Failed to parse Pywal JSON:", e);
            }
        }
    }

}
