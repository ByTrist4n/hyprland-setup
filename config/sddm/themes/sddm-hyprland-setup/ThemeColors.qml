import QtQuick 2.15
pragma Singleton

QtObject {
    id: root

    // Reference to loaded colors item from Pywal
    property var colorsItem: null
    // --- 1. SURFACES & BACKGROUNDS ---
    property color bgBase: colorsItem && colorsItem.color0 ? colorsItem.color0 : "#1a1008"
    property color bgSurface: colorsItem && colorsItem.color0 ? colorsItem.color0 : "#1a1008"
    property color bgSurfaceActive: colorsItem && colorsItem.color9 ? colorsItem.color9 : "#4a2a14"
    property color bgSurfaceDisabled: colorsItem && colorsItem.color8 ? colorsItem.color8 : "#2e1a0a"
    // --- 2. BORDERS ---
    property color borderBase: colorsItem && colorsItem.color8 ? colorsItem.color8 : "#2e1a0a"
    property color borderActive: colorsItem && colorsItem.color4 ? colorsItem.color4 : "#e08030"
    // --- 3. TEXT & ICONS ---
    property color fgPrimary: colorsItem && colorsItem.color15 ? colorsItem.color15 : "#f0d0a0"
    property color fgMuted: colorsItem && colorsItem.color7 ? colorsItem.color7 : "#d4a870"
    property color fgOnAccent: colorsItem && colorsItem.color0 ? colorsItem.color0 : "#1a1008"
    // --- 4. ACCENTS & STATES ---
    property color accentPrimary: colorsItem && colorsItem.color4 ? colorsItem.color4 : "#e08030"
    property color accentSecondary: colorsItem && colorsItem.color5 ? colorsItem.color5 : "#c07040"
    property color urgent: "#e05050"
    property color success: "#a6e3a1"
    property color warning: "#f9e2af"
    // Dynamic Loader for Pywal's Colors.qml
    property Loader pywalLoader

    pywalLoader: Loader {
        active: true
        asynchronous: false
        source: "Colors.qml"
        onStatusChanged: {
            if (status === Loader.Ready && item)
                root.colorsItem = item;

        }
    }

}
