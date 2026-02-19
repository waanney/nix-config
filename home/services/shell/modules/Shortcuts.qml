import qs.modules.controlcenter
import qs.services
// import Caelestia  // Module not installed
import Quickshell
import Quickshell.Io

Scope {
    id: root

    readonly property bool hasFullscreen: Niri.hasFullscreen

    IpcHandler {
        target: "drawers"

        function toggle(drawer: string): void {
            if (list().split("\n").includes(drawer)) {
                if (root.hasFullscreen && ["launcher", "session", "dashboard"].includes(drawer))
                    return;
                const visibilities = Visibilities.getForActive();
                visibilities[drawer] = !visibilities[drawer];
            } else {
                console.warn(`[IPC] Drawer "${drawer}" does not exist`);
            }
        }

        function list(): string {
            const visibilities = Visibilities.getForActive();
            return Object.keys(visibilities).filter(k => typeof visibilities[k] === "boolean").join("\n");
        }
    }

    IpcHandler {
        target: "controlCenter"

        function open(): void {
            WindowFactory.create();
        }
    }

    IpcHandler {
        target: "toaster"

        function info(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.info);
        }

        function success(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.Success);
        }

        function warn(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.warning);
        }

        function error(title: string, message: string, icon: string): void {
            Toaster.toast(title, message, icon, Toast.error);
        }
    }
}
