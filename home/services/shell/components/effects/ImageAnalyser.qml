import QtQuick

// Stub ImageAnalyser to replace Caelestia.Internal.ImageAnalyser
// Returns default dominant colour

Item {
    property Item sourceItem
    readonly property color dominantColour: "#888888"
    
    function requestUpdate(): void {
        // No-op in stub
    }
}
