import QtQuick

// Stub CavaProvider to replace Caelestia.Services.CavaProvider
// Returns empty audio visualization data

Item {
    property int bars: 64
    readonly property var values: {
        const arr = [];
        for (let i = 0; i < bars; i++) arr.push(0);
        return arr;
    }
}
