pragma Singleton

import Quickshell

// Stub module to replace Caelestia C++ plugin types
// These are minimal implementations to allow shell to load

Singleton {
    id: root

    // Stub for CUtils.toLocalFile
    function toLocalFile(path: url): string {
        const str = path.toString();
        if (str.startsWith("file://"))
            return str.substring(7);
        return str;
    }
}
