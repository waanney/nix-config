import QtQuick

// Stub FileSystemModel to replace Quickshell.Io.FileSystemModel
// Returns empty entries

ListModel {
    id: root
    
    property bool recursive: false
    property string path: ""
    property int filter: 0
    property var nameFilters: []
    property bool sortReverse: false
    
    readonly property var entries: []
}
