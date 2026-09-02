import QtQuick
pragma Singleton

QtObject {
    // --- 1. SURFACES & BACKGROUNDS ---
    // Main bar background
    readonly property color bgBase: "#11111b"
    // Pills & cards background
    readonly property color bgSurface: "#181825"
    // Hover & selected state background
    readonly property color bgSurfaceHover: "#313244"
    readonly property color bgSurfaceActive: "#45475a"
    // --- 2. BORDERS ---
    // Standard border color
    readonly property color borderBase: "#313244"
    readonly property color borderActive: "#89b4fa"
    // --- 3. TEXT & ICONS ---
    // Primary text & icon color
    readonly property color fgPrimary: "#cdd6f4"
    // Secondary / inactive text color
    readonly property color fgMuted: "#a6adc8"
    readonly property color fgOnAccent: "#11111b"
    // --- 4. ACCENTS & STATES ---
    // Primary accent color
    readonly property color accentPrimary: "#89b4fa"
    // Secondary accent color
    readonly property color accentSecondary: "#cba6f7"
    // Critical alerts & notifications
    readonly property color urgent: "#f38ba8"
    // Success & connected state
    readonly property color success: "#a6e3a1"
    readonly property color warning: "#f9e2af"
}
