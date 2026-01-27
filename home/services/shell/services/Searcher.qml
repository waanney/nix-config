import QtQuick

// Stub Searcher to replace Caelestia.Models.Searcher
// Minimal implementation for compatibility

Item {
    property var list: []
    property string key: ""
    property bool useFuzzy: false
    property var extraOpts: ({})
    
    readonly property var results: list
    property string query: ""
    
    function search(q: string): void {
        query = q;
    }
    
    function reset(): void {
        query = "";
    }
}
