import QtQuick

// Stub CachingImageManager to replace Caelestia.Internal.CachingImageManager
// Simplified implementation - just sets the source directly

Item {
    id: root
    
    property Image item
    property string path: ""
    property url cacheDir: ""
    
    function updateSource(): void {
        if (item && path)
            item.source = Qt.resolvedUrl(path);
    }
    
    onPathChanged: updateSource()
    Component.onCompleted: updateSource()
}
