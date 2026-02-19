pragma Singleton

import Quickshell
import Quickshell.Niri as QSNiri
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property var workspaces: QSNiri.Niri.workspaces
    readonly property var toplevels: QSNiri.Niri.toplevels
    readonly property var focusedWorkspace: QSNiri.Niri.focusedWorkspace
    readonly property var focusedWindow: QSNiri.Niri.focusedWindow

    function focusWorkspace(name: string): void {
        dispatch(["focus-workspace", name]);
    }

    function focusWorkspaceUp(): void {
        dispatch(["focus-workspace-up"]);
    }

    function focusWorkspaceDown(): void {
        dispatch(["focus-workspace-down"]);
    }

    function moveWindowToWorkspace(name: string): void {
        dispatch(["move-column-to-workspace", name]);
    }

    function dispatch(action: list<string>): void {
        dispatchProcess.command = ["niri", "msg", "action"].concat(action);
        dispatchProcess.running = true;
    }

    Process {
        id: dispatchProcess
        running: false
    }
}
