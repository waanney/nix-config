import QtQuick

// Stub LogindManager to replace Caelestia.Internal.LogindManager
// Provides session management signals

Item {
    signal aboutToSleep()
    signal lockRequested()
    signal unlockRequested()
}
