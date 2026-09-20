import QtQuick
pragma Singleton

QtObject {
    id: root

    // Reference to loaded colors item from Pywal
    property var colorsItem: null
    // --- 1. SURFACES & BACKGROUNDS ---
    property color bgBase: getColor("color0", "#1a1008")
    property color bgBaseSubtle: Qt.alpha(bgBase, 0.3)
    property color bgBaseMedium: Qt.alpha(bgBase, 0.6)
    property color bgBaseStrong: Qt.alpha(bgBase, 0.8)
    // --- 2. BORDERS ---
    property color borderBase: getColor("color8", "#2e1a0a")
    property color borderActive: getColor("color4", "#e08030")
    // --- 3. BUTTONS ---
    property color bgButton: Qt.alpha(getColor("color4", "#e08030"), 0.85)
    property color bgButtonHover: getColor("color4", "#e08030")
    // --- 4. TEXT & ICONS ---
    property color fgPrimary: getColor("color15", "#f0d0a0")
    property color fgMuted: Qt.alpha(getColor("color7", "#d4a870"), 0.5)
    property color fgOnAccent: getColor("color0", "#1a1008")
    // --- 5. ACCENTS & STATES ---
    property color accentPrimary: getColor("color4", "#e08030")
    property color accentSecondary: getColor("color5", "#c07040")
    property color urgent: "#e05050"
    property color success: "#a6e3a1"
    property color warning: "#f9e2af"
    // Dynamic Loader for Pywal's Colors.qml
    property Loader _pywalLoader

    // Helper function to safely fetch color with fallback
    function getColor(key, fallback) {
        return (colorsItem && colorsItem[key]) ? colorsItem[key] : fallback;
    }

    _pywalLoader: Loader {
        active: true
        asynchronous: true
        source: "Colors.qml"
        onStatusChanged: {
            if (status === Loader.Ready && item)
                root.colorsItem = item;

        }
    }

}
