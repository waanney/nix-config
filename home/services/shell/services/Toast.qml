pragma Singleton

import Quickshell

// Stub Toast enum to replace Caelestia.Toast
// Note: QML requires lowercase property/method names
// Code using Toast.Error should be updated to Toast.error

Singleton {
    readonly property int info: 0
    readonly property int warning: 1
    readonly property int error: 2
}
