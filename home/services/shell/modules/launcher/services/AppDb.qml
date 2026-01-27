import QtQuick

// Stub AppDb to replace Caelestia.AppDb
// Returns empty apps list and provides frequency tracking stub

Item {
    property string path: ""
    property var entries: []
    
    readonly property var apps: entries
    
    function incrementFrequency(id: string): void {
        console.log("AppDb.incrementFrequency:", id);
    }
    
    function getFrequency(id: string): int {
        return 0;
    }
}
