# Refactoring Plan

## Priority 1: Fix Dead/Orphaned Code (Done)

- `home/software/wayland/caido.nix` — removed (never imported)
- `home/software/wayland/wine.nix` — removed (never imported)

## Priority 2: Convert `system/default.nix` to a Proper Module

**Current** (`system/default.nix`):
Returns `{ inherit desktop laptop; }` — an attrset of lists. Used via fragile inline list concatenation in `hosts/default.nix`.

**Problem**: Not a real NixOS module. No option introspection, no `lib.mkIf`, no composability. The list concatenation pattern (`desktop ++ laptop ++ [...]`) is fragile and implicit.

**Proposed**:
```nix
{ lib, ... }: {
  options.waanne = {
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this is a laptop configuration";
    };
  };
  imports = [
    ./core
    ./hardware/graphics.nix
    ./hardware/fwupd.nix
    ./network
    ./programs
    ./services
  ] ++ lib.optionals config.waanne.isLaptop [
    ./hardware/bluetooth.nix
    ./services/backlight.nix
    ./services/power.nix
  ];
}
```

Then `hosts/default.nix` becomes:
```nix
{ waanne.isLaptop = true; }
```

## Priority 3: Simplify `hosts/default.nix`

**Current**: Imports `system` as a raw path, destructures the attrset, concatenates lists inline.

**Proposed**: Remove the `system/` result set pattern entirely. Have `system/` be a proper NixOS module directory. `hosts/` just imports `./system` and adds host-specific overrides.

## Priority 4: Clean Up Home Import Flow

**Current**:
1. `home/profiles/default.nix` creates `homeImports` attrset
2. Stores it in `_module.args`
3. `hosts/default.nix` reads `homeImports` from module args
4. Uses it in `home-manager.users.waanne.imports = homeImports."waanne@maclaurin"`

**Proposed**:
```nix
# In hosts/maclaurin/default.nix:
home-manager.users.waanne.imports = [
  ../../home
  ../../home/profiles/maclaurin
];
```

This eliminates the indirect pipeline and makes the flow obvious.

## Priority 5: Move Inline Host-Specific Imports

**Current**: `hosts/default.nix` adds these inline for maclaurin:
- `"${mod}/programs/gamemode.nix"`
- `"${mod}/services/gnome-services.nix"`
- `"${mod}/services/location.nix"`

**Proposed**: Move these into `hosts/maclaurin/default.nix` where they belong.

## Priority 6: Standardize Comment Language

Some comments are in Vietnamese, others in English. Pick one (English is standard for code).

## Priority 7: Add More Granular Tests

- Unit tests for `lib/repl.nix` (needs flake context mocking)
- VM integration test using `nixosTest`
- CI pipeline (GitHub Actions) running `nix flake check`

## Summary

| # | Change | Effort | Risk | Value |
|---|--------|--------|------|-------|
| 1 | Remove dead files | Trivial | None | Low |
| 2 | Convert system to proper module | Medium | Medium | High |
| 3 | Simplify host composition | Medium | Low | High |
| 4 | Clean home import flow | Small | Low | Medium |
| 5 | Move host-specific includes | Small | Low | Medium |
| 6 | Comment cleanup | Trivial | None | Low |
| 7 | Add more tests | Medium | None | High |
