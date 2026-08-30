# Operations

This document lists common commands for maintaining and applying the configuration.

## Development Shell

Enter the repository shell:

```bash
nix develop
```

The shell includes formatting tools and the custom `repl` helper.

## Formatting

Format Nix files using Alejandra:

```bash
nix fmt
```

## Checks

Run the root flake check:

```bash
nix flake check
```

## Building & Switching Configuration

### Using `nh` (Recommended Helper)

Rebuild and switch the live system:

```bash
nh os switch /etc/nixos
```

Build the system without switching (dry-build):

```bash
nh os build /etc/nixos
```

### Using Standard `nixos-rebuild`

Build the host without switching:

```bash
sudo nixos-rebuild build --flake .#maclaurin
```

Switch the live system:

```bash
sudo nixos-rebuild switch --flake .#maclaurin
```

## Home Manager Standalone

Switch Home Manager configuration independently:

```bash
home-manager switch --flake .#waanne@maclaurin
```

## Updating Inputs

Update all flake inputs:

```bash
nix flake update
```

Update a single input (e.g. `nixpkgs`):

```bash
nix flake lock --update-input nixpkgs
```

Review `flake.lock` before committing lock file changes.

## Cleanup & Garbage Collection

Using `nh`:

```bash
nh clean all
```

Or using native nix-collect-garbage:

```bash
sudo nix-collect-garbage -d
```

Use cleanup commands carefully because they remove previous generation rollbacks.
