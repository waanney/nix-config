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
    //   toplevels.values    – array of { id, title, appId, workspaceId, isFocused }
    //   focusedWorkspace    – one of the workspaces entries, or null
    //   focusedWindow       – { id, title, appId, workspaceId }, or null
    property var workspaces:     ({ values: [] })
    property var toplevels:      ({ values: [] })
    property var focusedWorkspace: null
    property var focusedWindow:    null

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

    // ── event-stream: for instant focused-window updates ──────────────────
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
                    }
                } catch(e) {}
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
        }));
        workspaces = { values: arr };
        focusedWorkspace = arr.find(w => w.isFocused) ?? null;
    }

    function _applyToplevels(data: var): void {
        const arr = (data ?? []).map(w => ({
            id:          w.id          ?? 0,
            title:       w.title       ?? "",
            appId:       w.app_id      ?? "",
            workspaceId: w.workspace_id ?? null,
            isFocused:   !!w.is_focused
        }));
        toplevels = { values: arr };
    }
}
