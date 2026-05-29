# Project Overview

This repository is a personal NixOS configuration centered on the `maclaurin` host. The root flake uses `flake-parts` and imports host definitions, Home Manager profiles, and custom packages.

## Configuration Flow

1. `flake.nix` imports `hosts/`, `home/profiles/`, and `pkgs/`.
2. `hosts/default.nix` exposes `nixosConfigurations.maclaurin`.
3. `system/default.nix` defines shared `desktop` and `laptop` module lists.
4. `home/profiles/default.nix` exposes the Home Manager import set for `waanne@maclaurin`.
5. `home/profiles/maclaurin/default.nix` composes user applications, services, Wayland configuration, terminal tools, and the shell.

## Major Areas

- `system/` contains NixOS modules that require system-level privileges.
- `home/` contains user-level Home Manager modules.
- `home/services/shell/` contains the Quickshell/Caelestia desktop shell.
- `pkgs/` contains packages exported by the flake.
- `nixdev/` contains reusable development shells and templates.
- `assets/` stores static resources such as wallpapers.

## Documentation Layout

Human-facing Markdown lives in `docs/`. AI-agent-facing Markdown lives in `.agents/`. Source folders intentionally do not contain local Markdown files; use `docs/source-map.md` as the grouped source tree map.
