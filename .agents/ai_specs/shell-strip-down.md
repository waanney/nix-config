# Spec: Strip Quickshell to Top Bar + Niri Lock Screen

## Goal

Replace the full Caelestia desktop shell with a minimal Quickshell top bar only. Configure Niri lock screen to show wallpaper as background.

## Scope

- `home/services/shell/` - simplify to only bar QML + dependencies
- `home/software/wayland/niri/binds.nix` - update IPC-dependent bindings
- `home/software/wayland/niri/settings.nix` - update spawn-at-startup
- `home/services/wayland/hypridle.nix` - ensure lock flow works with niri
- `home/services/shell/default.nix` - strip dependencies
- Wallpaper (`awww` daemon) - keep as is

## Out Of Scope

- Terminal emulators, editors, CLI tools
- System-level services (greetd, pipewire, etc.)
- Stylix/color scheme changes
- Niri window rules and workspace config

## Implementation Notes

### 1. Strip shell/ directory

- Delete: `modules/` (except bar), `components/`, `config/`, `services/`, `utils/`, `assets/`, `plugin/`, `extras/`, `nix/`
- Keep: `bar.qml` (new minimal), `default.nix` (simplified), `assets/wallpapers/` reference
- New `bar.qml` only imports: Quickshell, QtQuick, QtQuick.Layouts
- No IPC, no drawers, no background, no lock screen from quickshell

### 2. Simplify `default.nix`

- Dependencies: `quickshell`, `qtdeclarative`, `qt5compat` (for bar tray)
- Remove: `matugen`, `fish`, `networkmanager`, `libqalculate`, `brightnessctl`
- Remove all `xdg.configFile` except for bar.qml
- Remove QML2_IMPORT_PATH (only needed by full shell)

### 3. Update Niri keybindings (`binds.nix`)

| Old | New |
|-----|-----|
| `XF86MonBrightnessUp/Down` → `quickshell ipc call brightness` | → direct `brightnessctl` |
| `Mod+Space` → `quickshell ipc call drawers toggle launcher` | → `rofi -show drun` |
| `Ctrl+Alt+L` → `quickshell ipc call lock lock` | → `loginctl lock-session` |

### 4. Lock screen flow

- Enable hyprlock (`enable = true` in hyprlock.nix)
- hyprlock config already has wallpaper path: `${self}/assets/wallpapers/tree.jpg`
- hypridle: lock_cmd → hyprlock, timeout → `loginctl lock-session`
- Niri spawn-at-startup: remove `hyprlock` spawn (hypridle manages it)

### 5. Spawn changes

- Remove `quickshell` from spawn-at-startup
- Add `quickshell` launch via new minimal bar instead

## Acceptance Criteria

- `nix flake check` passes with no quickshell IPC errors
- Top bar visible on niri with clock, workspaces, status icons
- `Super+Space` opens rofi
- `Ctrl+Alt+L` locks screen with wallpaper background
- Brightness keys work directly
- No quickshell IPC calls in niri config

## Verification

```bash
nix fmt
nix flake check
```
