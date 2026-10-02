import QtQuick
import Quickshell
import Quickshell.Services.UPower
pragma Singleton

Singleton {
    id: root

    // Fetch primary display battery or fallback device
    readonly property var battery: UPower.displayDevice
    readonly property bool isAvailable: battery != null && battery.isPresent
    readonly property real percent: isAvailable ? battery.percentage : 1
    readonly property bool isCharging: isAvailable && (battery.state === UPowerDeviceState.Charging || battery.state === UPowerDeviceState.FullyCharged)
}
