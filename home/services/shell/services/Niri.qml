pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Niri IPC service using direct subprocess polling and event-stream.
// Uses persistent shell-loop processes (not one-shot) for continuous updates.
Singleton {
    id: root

    // Exposed data – structured to match what Workspace.qml / ActiveWindow.qml expect:
    //   workspaces.values   – array of { id, name, output, isFocused }
    //   toplevels.values    – array of { id, title, appId, workspaceId, isFocused, isFullscreen }
    //   focusedWorkspace    – one of the workspaces entries, or null
    //   focusedWindow       – { id, title, appId, workspaceId }, or null
    property var workspaces:     ({ values: [] })
    property var toplevels:      ({ values: [] })
    property var focusedWorkspace: null
    property var focusedWindow:    null

    // ── keyboard state ─────────────────────────────────────────────────────
    property bool   capsLock:       false
    property bool   numLock:        false
    property string kbLayoutFull:   ""   // e.g. "English (US)"
    property string kbLayout:       ""   // e.g. "us"
    property string defaultKbLayout: "" // first layout in the list
    property var    _kbLayoutNames:  [] // full list of layout names from Niri

    // ── fullscreen helper ──────────────────────────────────────────────────
    // true when any window in the focused workspace is fullscreen
    readonly property bool hasFullscreen:
        toplevels.values.some(w => w.isFullscreen && w.workspaceId === focusedWorkspace?.id)

    // ── focused screen helper ──────────────────────────────────────────────
    // Returns true if the ShellScreen corresponds to the focused workspace output
    function isFocusedScreen(screen: ShellScreen): bool {
        return focusedWorkspace?.output === screen.name;
    }

    // ── persistent workspace poller (shell loop, runs forever) ────────────
    // Outputs one JSON line every 100ms; SplitParser fires on each line.
    // niri msg --json outputs compact single-line JSON, so one line = one snapshot.
    Process {
        id: wsLoop
        running: true
        command: ["bash", "-c",
            "while true; do niri msg --json workspaces 2>/dev/null; sleep 0.1; done"]
        stdout: SplitParser {
            onRead: line => {
                if (line.startsWith("[")) {
                    try { root._applyWorkspaces(JSON.parse(line)); } catch(e) {}
                }
            }
        }
    }

    // ── persistent windows poller ─────────────────────────────────────────
    Process {
        id: winLoop
        running: true
        command: ["bash", "-c",
            "while true; do niri msg --json windows 2>/dev/null; sleep 0.1; done"]
        stdout: SplitParser {
            onRead: line => {
                if (line.startsWith("[")) {
                    try { root._applyToplevels(JSON.parse(line)); } catch(e) {}
                }
            }
        }
    }

    // ── event-stream: focused-window + keyboard layout events ──────────────
    // stdbuf -oL forces line-buffered stdout so events flush immediately
    Process {
        id: eventStream
        running: true
        command: ["stdbuf", "-oL", "niri", "msg", "event-stream"]
        stdout: SplitParser {
            onRead: line => {
                if (!line || line.trim() === "") return;
                try {
                    const ev  = JSON.parse(line);
                    const key = Object.keys(ev)[0];
                    if (key === "WindowFocusChanged") {
                        const w = ev[key];
                        root.focusedWindow = w && w.id != null ? {
                            id: w.id,
                            title: w.title ?? "",
                            appId: w.app_id ?? "",
                            workspaceId: w.workspace_id ?? null
                        } : null;
                    } else if (key === "KeyboardLayoutsChanged") {
                        const data = ev[key];
                        root._kbLayoutNames = data?.keyboard_layouts?.names ?? [];
                        const idx = data?.keyboard_layouts?.current_idx ?? 0;
                        root._applyKbLayout(idx);
                    } else if (key === "KeyboardLayoutSwitched") {
                        root._applyKbLayout(ev[key]?.idx ?? 0);
                    }
                } catch(e) {}
            }
        }
    }

    // ── capsLock / numLock: poll sysfs every 500ms ─────────────────────────
    Process {
        id: lockKeyPoller
        running: true
        command: ["bash", "-c",
            "while true; do " +
            "  caps=$(cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -1); " +
            "  num=$(cat /sys/class/leds/input*::numlock/brightness 2>/dev/null | head -1); " +
            "  echo \"${caps:-0} ${num:-0}\"; sleep 0.5; done"]
        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split(" ");
                root.capsLock = (parts[0] === "1");
                root.numLock  = (parts[1] === "1");
            }
        }
    }

    // ── dispatch helper ────────────────────────────────────────────────────
    function dispatch(args: list<string>): void {
        dispatchProc.command = ["niri", "msg", "action"].concat(args);
        dispatchProc.running = true;
    }

    function focusWorkspace(name: string):        void { dispatch(["focus-workspace",          name]); }
    function focusWorkspaceUp():                  void { dispatch(["focus-workspace-up"]);              }
    function focusWorkspaceDown():                void { dispatch(["focus-workspace-down"]);             }
    function moveWindowToWorkspace(name: string): void { dispatch(["move-column-to-workspace", name]); }

    Process {
        id: dispatchProc
        running: false
    }

    // ── internal normalization ─────────────────────────────────────────────
    function _applyWorkspaces(data: var): void {
        const arr = (data ?? []).map(w => ({
            id:        w.id   ?? 0,
            name:      w.name ?? null,
            output:    w.output ?? "",
            isFocused: !!w.is_focused
        })).sort((a, b) => {
            const na = a.name ?? String(a.id);
            const nb = b.name ?? String(b.id);
            return na.localeCompare(nb);
        });
        workspaces = { values: arr };
        focusedWorkspace = arr.find(w => w.isFocused) ?? null;
    }

    function _applyToplevels(data: var): void {
        const arr = (data ?? []).map(w => ({
            id:          w.id           ?? 0,
            title:       w.title        ?? "",
            appId:       w.app_id       ?? "",
            workspaceId: w.workspace_id ?? null,
            isFocused:   !!w.is_focused,
            isFullscreen: !!w.is_fullscreen
        }));
        toplevels = { values: arr };
    }

    // Convert layout index to short code + full name
    function _applyKbLayout(idx: int): void {
        const full = root._kbLayoutNames[idx] ?? "";
        root.kbLayoutFull = full;
        // Extract short code: "English (US)" → "us", "Vietnamese" → "vn", etc.
        // Niri returns names like "English (US)", "Vietnamese" – try to parse code
        // by running setxkbmap -query as fallback.
        // For now, use a simple slug from the first word:
        const match = full.toLowerCase().match(/[a-z]+/);
        const shortCode = (match && match.length > 0) ? match[0] : full;
        root.kbLayout = shortCode;
        if (root.defaultKbLayout === "" && root._kbLayoutNames.length > 0) {
            const defaultFull = root._kbLayoutNames[0] ?? "";
            const defaultMatch = defaultFull.toLowerCase().match(/[a-z]+/);
            root.defaultKbLayout = (defaultMatch && defaultMatch.length > 0) ? defaultMatch[0] : defaultFull;
        }
    }
}
