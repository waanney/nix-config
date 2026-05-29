# Operations

This document lists common commands for maintaining and applying the configuration.

## Development Shell

Enter the repository shell:

```bash
nix develop
```

The shell includes formatting tools and the custom `repl` helper.

## Formatting

Format Nix files:

```bash
nix fmt
```

## Checks

Run the root flake check:

```bash
nix flake check
```

Build the host without switching:

```bash
sudo nixos-rebuild build --flake .#maclaurin
```

Switch the live system only after the build is acceptable:

```bash
sudo nixos-rebuild switch --flake .#maclaurin
```

## Updating Inputs

Update flake inputs:

```bash
nix flake update
```

Review `flake.lock` before committing lock file changes.

## Cleanup

Remove old generations and unused store paths:

```bash
sudo nix-collect-garbage -d
```

Use cleanup commands carefully because they affect rollback options.
