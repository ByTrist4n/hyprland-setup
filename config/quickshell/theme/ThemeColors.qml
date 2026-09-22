import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

QtObject {
    id: root

    property FileView colorsFile
    property var walColors: null
    // DEFAULT PALETTE FALLBACKS (color0..color15 + background/foreground)
    readonly property var fallback: {
        "background": "#1e1e2e",
        "foreground": "#cdd6f4",
        "cursor": "#f5e0dc",
        "color0": "#181825",
        "color1": "#f38ba8",
        "color2": "#a6e3a1",
        "color3": "#f9e2af",
        "color4": "#89b4fa",
        "color5": "#cba6f7",
        "color6": "#94e2d5",
        "color7": "#bac2de",
        "color8": "#45475a",
        "color9": "#f38ba8",
        "color10": "#a6e3a1",
        "color11": "#f9e2af",
        "color12": "#89b4fa",
        "color13": "#cba6f7",
        "color14": "#94e2d5",
        "color15": "#a6adc8"
    }
    // --- 1. SURFACES & BACKGROUNDS ---
    readonly property color bgBase: getColor("background")
    readonly property color bgBaseSubtle: Qt.alpha(bgBase, 0.3)
    readonly property color bgBaseMedium: Qt.alpha(bgBase, 0.6)
    readonly property color bgBaseStrong: Qt.alpha(bgBase, 0.8)
    readonly property color bgSurface: getColor("color0")
    readonly property color bgSurfaceActive: getColor("color8")
    // --- 2. BORDERS ---
    readonly property color borderBase: getColor("color8")
    readonly property color borderActive: getColor("color4")
    // --- 3. BUTTONS ---
    readonly property color bgButton: Qt.alpha(accentPrimary, 0.85)
    readonly property color bgButtonHover: accentPrimary
    readonly property color fgButton: getColor("background")
    // --- 4. TEXT & ICONS ---
    readonly property color fgPrimary: getColor("foreground")
    readonly property color fgMuted: Qt.alpha(getColor("color7"), 0.6)
    readonly property color fgOnAccent: getColor("background")
    // --- 5. ACCENTS & STATES ---
    readonly property color accentPrimary: getColor("color4")
    readonly property color accentSecondary: getColor("color5")
    // Hardcoded status colors
    readonly property color urgent: "#ff5555"
    readonly property color success: "#50fa7b"
    readonly property color warning: "#f1fa8c"

    // Helper function to resolve color with fallback safely
    function getColor(key) {
        if (walColors && walColors[key] !== undefined)
            return walColors[key];

        return fallback[key] !== undefined ? fallback[key] : "#000000";
    }

    colorsFile: FileView {
        path: Quickshell.env("HOME") + "/.cache/wal/colors.json"
        onLoaded: {
            try {
                const parsed = JSON.parse(text());
                if (parsed) {
                    // Merge special colors and main colors into one flat object if present
                    let merged = {
                    };
                    if (parsed.special)
                        Object.assign(merged, parsed.special);

                    if (parsed.colors)
                        Object.assign(merged, parsed.colors);

                    root.walColors = merged;
                }
            } catch (e) {
                console.log("Failed to parse Pywal JSON:", e);
            }
        }
    }

}
