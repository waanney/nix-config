import QtQuick

// Stub ImageAnalyser to replace Caelestia.Internal.ImageAnalyser
// Returns fixed luminance value since image analysis requires C++ code

Item {
    property var source
    readonly property real luminance: 0.5  // Default mid-luminance
}
