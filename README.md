 NixOS Configuration
======================

 Overview
-----------
This repository hosts my complete NixOS setup, including declarative system modules, Home Manager profiles, custom packages, and reusable development shells. Everything is flake-based so hosts and user environments stay in sync across machines.

 Layout Highlights
-------------------
- `flake.nix` / `flake.lock` – entry point exposing system configurations, Home Manager, custom packages, and dev shells.
- `hosts/` – per-machine profiles (e.g. `maclaurin`) that compose modules from `system/` and `home/`.
- `system/` – core NixOS modules split into `core/`, `hardware/`, `network/`, `programs/`, and `services/`.
- `home/` – Home Manager modules for shared software, editors (Neovim, VS Code), Wayland setup, terminals, and services.
- `pkgs/` – in-tree derivations such as SF Pro fonts and a `repl` helper script.
- `nixdev/templates/` – single-file flake templates for web, AI/ML, Rust, and game development environments.
- `assets/` – wallpapers and other static resources referenced by the configuration.

 Usage
-------
1. **Build a host**  
   ```bash
   nixos-rebuild switch --flake .#maclaurin
   ```
2. **Activate Home Manager (if not using the NixOS module)**  
   ```bash
   home-manager switch --flake .#waanne@maclaurin
   ```
3. **Enter a dev shell directly from this repo**  
   ```bash
   nix develop .#ai-dev
   ```

 Template Quickstart
---------------------
Each template in `nixdev/templates/` is its own flake. Initialize a new project with:
```bash
nix flake init -t /etc/nixos/nixdev#web-dev
direnv allow  # if you use direnv + use flake
```

 Custom Packages
-----------------
- `pkgs/SF-Pro` and `pkgs/SF-Pro-mono` package Apple’s SF font families for system-wide use.
- `pkgs/repl` provides a convenient `repl` script that opens `nix repl` preloaded with the system flake.

 Notes
-------
- Run `nix flake update` to pull fresh inputs before rebuilding.
- Use `sudo nix-collect-garbage -d` periodically to prune old generations.
- Sensitive host-specific secrets are managed outside this repository.

