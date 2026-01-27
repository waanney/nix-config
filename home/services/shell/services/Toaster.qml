pragma Singleton

import Quickshell

// Stub Toaster to replace Caelestia C++ plugin
// Just logs to console instead of showing toast notifications

Singleton {
    id: root

    function toast(title: string, message: string, icon: string, severity: int): void {
        const level = severity === 2 ? "ERROR" : severity === 1 ? "WARN" : "INFO";
        console.log(`[${level}] Toast: ${title} - ${message} (${icon})`);
    }
}
