# Agent Project Map

## Root Flow

- `flake.nix` is the root flake.
- The root flake imports `home/profiles`, `hosts`, and `pkgs`.
- `hosts/default.nix` exposes `nixosConfigurations.maclaurin`.
- `system/default.nix` defines reusable `desktop` and `laptop` module lists.
- `home/profiles/default.nix` exposes Home Manager imports for `waanne@maclaurin`.

## System Side

- `system/core/` handles boot, users, security, locale, timezone, input methods, and zram.
- `system/hardware/` handles graphics, firmware updates, and Bluetooth.
- `system/network/` handles NetworkManager and Avahi.
- `system/nix/` handles Nix daemon behavior, nixpkgs settings, caches, and `nh`.
- `system/programs/` handles system-level programs such as fonts, Qt, XDG portals, Zsh, and GameMode.
- `system/services/` handles system services such as PipeWire, Docker, greetd, databases, virtualization, and power services.

## Home Manager Side

- `home/default.nix` defines the base user, state version, manuals, nix-index, and Stylix configuration.
- `home/profiles/maclaurin/default.nix` composes editors, user services, shell, desktop software, Wayland settings, and terminal emulator settings.
- `home/terminal/` handles CLI tools, shells, prompt, terminal emulators, Yazi, Git, GPG, tmux, and agent tooling.
- `home/software/` handles graphical applications, browsers, media tools, Rofi, GTK, and Wayland applications.
- `home/services/` handles user services and the shell.

## Custom Packages and Templates

- `pkgs/default.nix` exports `repl`, `SF-Pro`, and `SF-Pro-mono`.
- `nixdev/flake.nix` exports development shells and flake templates from `nixdev/templates/`.

## Documentation

- `docs/` is for human guides.
- `.agents/` is for agent rules, specs, and context.
- `docs/source-map.md` replaces scattered folder-level READMEs.
