# Agent Shell Map

The desktop shell under `home/services/shell/` is a lightweight Quickshell-based desktop interface for Niri / Wayland.

## Top-Level Structure

- `default.nix` - installs Quickshell dependencies and symlinks shell files into `~/.config/quickshell/`.
- `shell.qml` - main QML layout containing topbar panel, workspace pills, status widgets, dropdown backdrop, and the floating bottom dock.
- `components/` - modular QML widgets and components:
  - `Dock.qml` - auto-hiding floating application dock with launch/focus logic.
  - `ClockWidget.qml` - date and time display widget with live tooltip/popup support.
  - `DashboardTab.qml` - system overview tab inside dropdown cards.
  - `MediaTab.qml` - active MPRIS player controller and position slider.
  - `PerformanceTab.qml` - CPU, RAM, temperature, and hardware stats visualizer.
  - `WorkspaceList.qml` - dynamic Niri workspace switcher pills.
  - `DropdownCard.qml` - expandable popup card container.
  - `Theme.qml` - shared color scheme and font variables matching Stylix/Catppuccin.
- `sysinfo.sh` - fast asynchronous metric collection script returning JSON data (WiFi, IP, battery, volume, brightness, RAM, CPU, temperature, media, and weather).

## Editing Rules

- Keep UI widgets self-contained inside `components/`.
- Access system metrics via the `sysInfo` object bound to `sysinfo.sh` execution.
- Maintain fast execution in `sysinfo.sh` (< 0.2s) without blocking loops or heavy synchronous network calls.
- Keep polling intervals reasonable (`niriTimer` >= 200ms, `sysInfoTimer` >= 2000ms) to avoid CPU churn.
- Ensure compositor actions use correct Niri IPC syntax (`niri msg action ...` or `niri msg -j ...`).
