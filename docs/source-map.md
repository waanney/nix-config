# Source Map

This document replaces the per-folder README files. It gives a grouped map of the source tree without scattering Markdown through every source directory.

## Root

- `flake.nix` - root flake entrypoint using `flake-parts`.
- `flake.lock` - pinned input revisions.
- `journal_logs.txt` - local log capture currently present in the worktree.

## Host And System Configuration

- `hosts/` - NixOS host definitions.
- `hosts/maclaurin/` - host-specific configuration and generated hardware configuration for `maclaurin`.
- `system/` - reusable NixOS module stacks.
- `system/core/` - boot, users, security, locale, timezone, input method, and zram.
- `system/hardware/` - graphics, firmware updates, and Bluetooth.
- `system/network/` - NetworkManager and Avahi.
- `system/nix/` - Nix daemon behavior, nixpkgs settings, substituters, and `nh`.
- `system/programs/` - system-level program integrations such as fonts, Qt, XDG portals, Zsh, Home Manager, and GameMode.
- `system/services/` - services such as PipeWire, Docker, greetd, databases, virtualization, Tailscale, power, and backlight handling.

## Home Manager Configuration

- `home/` - Home Manager modules for the `waanne` user.
- `home/profiles/` - host-specific Home Manager import sets.
- `home/profiles/maclaurin/` - `maclaurin` user profile composition.
- `home/shared/colors/` - shared color schemes used by Stylix and shell theming.

## Editors

- `home/editors/` - editor modules.
- `home/editors/nvim/` - Neovim configuration, packages, Lazy.nvim bootstrap, options, and plugins.
- `home/editors/nvim/lua/plugins/` - plugin modules grouped by editing, git, language, LSP, navigation, UI, and utility concerns.

## Terminal

- `home/terminal/` - terminal, shell, CLI, and agent tooling.
- `home/terminal/shell/` - Zsh, Nushell, and Starship configuration.
- `home/terminal/emulators/` - WezTerm and Foot terminal modules.
- `home/terminal/software/` - CLI tools such as Git, GPG, tmux, Yazi, bat, bottom, lazygit, skim, zoxide, atuin, cava, neofetch, XDG helpers, and Nix tooling.
- `home/terminal/software/yazi/theme/` - Yazi theme fragments.
- `home/terminal/agents/` - terminal-based AI and coding agent tools.

## Desktop Software

- `home/software/` - user-level graphical and desktop applications.
- `home/software/browsers/` - Firefox and Chrome modules.
- `home/software/media/` - MPV, OBS, and RNNoise/PipeWire media configuration.
- `home/software/rofi/` - Rofi launcher configuration.
- `home/software/wayland/` - Wayland packages and session variables.
- `home/software/wayland/niri/` - Niri settings, keybinds, window rules, and display switching helper.

## User Services And Shell

- `home/services/` - user-level services and shell configuration.
- `home/services/media/` - media control service modules.
- `home/services/system/` - user systemd services such as GPG agent, polkit agent, power monitor, Obsidian sync, and Syncthing.
- `home/services/wayland/` - Wayland-specific user services such as hypridle.
- `home/services/shell/` - Quickshell/Caelestia shell source and packaging.

## Quickshell/Caelestia Shell

- `home/services/shell/modules/` - visible shell surfaces: bar, launcher, dashboard, control center, lock screen, notifications, sidebar, OSD, session, utilities, background, drawers, area picker, and window info.
- `home/services/shell/components/` - reusable QML UI primitives, controls, containers, effects, file dialog, image helpers, widgets, and misc helpers.
- `home/services/shell/services/` - QML singletons for audio, media, network, compositor state, colors, wallpapers, weather, notifications, toasts, requests, search, visibility, brightness, and file system support.
- `home/services/shell/config/` - typed QML configuration objects.
- `home/services/shell/utils/` - QML utilities and JavaScript fuzzy search helpers.
- `home/services/shell/assets/` - images, animations, PAM snippets, shaders, and terminal launch script.
- `home/services/shell/plugin/` - native Qt/QML plugin source.
- `home/services/shell/plugin/src/Caelestia/` - QML-exposed native classes for app database, utilities, image analysis, calculator, requests, toasts, internal helpers, models, and services.
- `home/services/shell/nix/` - shell derivation, Home Manager module support, and app-to-systemd helper.
- `home/services/shell/extras/` - native extra modules and version metadata.

## Packages, Templates, Assets, And Helpers

- `pkgs/` - custom package outputs for `repl`, `SF-Pro`, and `SF-Pro-mono`.
- `lib/` - reusable flake helper logic, currently the REPL helper.
- `nixdev/` - reusable development shell templates.
- `nixdev/templates/` - web, AI, Rust, game, LaTeX, Java, and cybersecurity templates.
- `assets/wallpapers/` - wallpaper images used by desktop and shell configuration.

## Documentation Roots

- `docs/` - human-facing Markdown.
- `.agents/` - AI-agent-facing Markdown, specs, context, and workflow material.
