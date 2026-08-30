# Source Map

This document replaces the per-folder README files. It gives a grouped map of the source tree without scattering Markdown through every source directory.

## Root

- `flake.nix` - root flake entrypoint using `flake-parts`.
- `flake.lock` - pinned input revisions.
- `.gitignore` - git ignore rules for test and build artifacts.

## Host And System Configuration

- `hosts/` - NixOS host definitions.
- `hosts/maclaurin/` - host-specific configuration and generated hardware configuration for `maclaurin`.
- `system/` - reusable NixOS module stacks.
- `system/core/` - boot, users, security, locale, timezone, input method, and zram.
- `system/hardware/` - graphics, firmware updates, and Bluetooth.
- `system/network/` - NetworkManager and Avahi.
- `system/nix/` - Nix daemon behavior, nixpkgs settings, substituters, and `nh`.
- `system/programs/` - system-level program integrations such as fonts, Qt, XDG portals, Zsh, and Home Manager.
- `system/services/` - services such as PipeWire, Docker, greetd, MySQL, PostgreSQL, Tailscale, power, and backlight handling.

## Home Manager Configuration

- `home/` - Home Manager modules for the `waanne` user.
- `home/profiles/` - host-specific Home Manager import sets and `homeConfigurations` export.
- `home/profiles/maclaurin/` - `maclaurin` user profile composition.
- `home/shared/colors/` - shared color schemes used by Stylix and shell theming.

## Editors

- `home/editors/` - editor modules.
- `home/editors/nvim/` - Neovim configuration, packages, Lazy.nvim bootstrap, options, and plugins.
- `home/editors/nvim/lua/plugins/` - plugin modules grouped by editing, git, language, LSP (`conform.nvim`, `lspconfig`), navigation (`oil.nvim`, `telescope`), UI, and utility concerns.

## Terminal

- `home/terminal/` - terminal, shell, CLI, and agent tooling.
- `home/terminal/shell/` - Zsh, Nushell, and Starship configuration.
- `home/terminal/emulators/` - WezTerm terminal configuration.
- `home/terminal/software/` - CLI tools such as Git, GPG, tmux, Yazi, bat, bottom, lazygit, skim, zoxide, atuin, XDG helpers, and Nix tooling.
- `home/terminal/software/yazi/theme/` - Yazi theme fragments.
- `home/terminal/agents/` - terminal-based AI session manager (`tm-ai`, `tm-ai-picker`, `tm-ai-list`, `tm-ai-state`) and AI agent packages.

## Desktop Software

- `home/software/` - user-level graphical and desktop applications.
- `home/software/browsers/` - Firefox and Chrome modules.
- `home/software/media/` - MPV, OBS, and RNNoise/PipeWire media configuration.
- `home/software/rofi/` - Rofi launcher configuration.
- `home/software/wayland/` - Wayland packages and session variables.
- `home/software/wayland/niri/` - Niri settings, keybinds, window rules, and display switching helper.

## User Services And Desktop Shell

- `home/services/` - user-level services and shell configuration.
- `home/services/media/` - media control service modules.
- `home/services/system/` - user systemd services such as GPG agent, polkit agent, power monitor, Obsidian sync, and Syncthing.
- `home/services/wayland/` - Wayland-specific user services such as hypridle.
- `home/services/shell/` - lightweight Quickshell desktop topbar and dock:
  - `shell.qml` - main QML layout for topbar panel, backdrop, dropdown cards, and floating dock.
  - `components/` - modular QML components (`Dock.qml`, `ClockWidget.qml`, `DashboardTab.qml`, `MediaTab.qml`, `PerformanceTab.qml`, `WorkspaceList.qml`, `DropdownCard.qml`, `Theme.qml`).
  - `sysinfo.sh` - fast asynchronous system metrics script providing JSON data.

## Packages, Templates, Tests, Assets, And Helpers

- `pkgs/` - custom package outputs for `repl`.
- `lib/` - reusable flake helper logic, currently the REPL helper.
- `tests/` - test suite for Neovim LSP, completion, formatting, navigation, and LaTeX compilation.
- `nixdev/` - reusable development shell templates.
- `nixdev/templates/` - web, AI, Rust, game, LaTeX, Java, and cybersecurity templates.
- `assets/wallpapers/` - wallpaper images used by desktop and shell configuration.

## Documentation Roots

- `docs/` - human-facing Markdown.
- `.agents/` - AI-agent-facing Markdown, specs, context, and workflow material.
