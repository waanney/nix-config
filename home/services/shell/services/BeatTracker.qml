import QtQuick

// Stub BeatTracker to replace Caelestia.Services.BeatTracker
// Returns no-beat state

Item {
    readonly property bool beat: false
    readonly property real bpm: 0
}
