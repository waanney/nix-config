pragma Singleton

import Quickshell

Singleton {
    property var screens: new Map()
    property var bars: new Map()

    function load(screen: ShellScreen, visibilities: var): void {
        screens.set(screen, visibilities);
    }

    function getForActive(): PersistentProperties {
        // Find the screen whose output name matches Niri's focused workspace output
        const focused = [...screens.keys()].find(s => Niri.isFocusedScreen(s));
        // Fallback to first registered screen (handles single-monitor setups)
        return screens.get(focused ?? [...screens.keys()][0]);
    }
}
