import QtQuick

// Stub HyprExtras to replace Caelestia.Internal.HyprExtras
// Minimal implementation for compatibility

Item {
    id: root
    
    readonly property var options: ({})
    readonly property var devices: ({
        keyboards: []
    })
    
    function message(msg: string): void {
        console.log("HyprExtras.message:", msg);
    }
    
    function batchMessage(msgs: list<string>): void {
        for (const msg of msgs)
            console.log("HyprExtras.batchMessage:", msg);
    }
    
    function applyOptions(opts: var): void {
        console.log("HyprExtras.applyOptions:", JSON.stringify(opts));
    }
    
    function refreshDevices(): void {
        console.log("HyprExtras.refreshDevices");
    }
}
