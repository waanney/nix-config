import QtQuick

// Stub CircularIndicatorManager to replace Caelestia.Internal.CircularIndicatorManager
// Manages progress animation state

Item {
    id: root
    
    property int indeterminateAnimationType: 0
    property real progress: 0
    property real rotation: progress * 360
    property real startFraction: 0
    property real endFraction: progress
    property real completeEndProgress: 0
    property int duration: 1500
    property int completeEndDuration: 500
}
