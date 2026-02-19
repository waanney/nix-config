pragma Singleton

import Quickshell
import QtQuick

/// HTTP helper singleton.
/// Usage: Requests.get(url, callback)
/// callback receives the response body as a string, or "" on failure.
Singleton {
    id: root

    function get(url: string, callback: var): void {
        const xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return;
            if (xhr.status >= 200 && xhr.status < 300) {
                callback(xhr.responseText);
            } else {
                console.warn("Requests.get failed [" + url + "]: HTTP " + xhr.status);
                callback("");
            }
        };
        xhr.open("GET", url);
        xhr.send();
    }
}
