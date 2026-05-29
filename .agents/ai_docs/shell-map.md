# Agent Shell Map

The shell under `home/services/shell/` is a Quickshell/Caelestia desktop shell.

## Top-Level Structure

- `default.nix` installs Quickshell dependencies and links shell files into the user's Quickshell config.
- `shell.qml` is the main QML entrypoint.
- `modules/` contains visible shell surfaces.
- `components/` contains reusable QML UI primitives.
- `services/` contains shared QML state and command wrappers.
- `config/` contains typed configuration objects.
- `utils/` contains QML and JavaScript helpers.
- `assets/` contains images, PAM snippets, shaders, and scripts.
- `plugin/` contains native C++ Qt/QML plugin code.
- `nix/` contains packaged shell derivations and Home Manager module support.

## Editing Rules

- Put reusable UI controls in `components/controls/`.
- Put surface-specific UI in `modules/`.
- Put shared state in `services/`.
- Put static settings shapes in `config/`.
- Put native QML-exposed behavior in `plugin/src/Caelestia/`.
- Keep bar popouts and control center panes consistent when they expose the same device or service.

## Common Risk Areas

- Display and compositor commands must match the exact compositor CLI syntax.
- Lock screen changes may involve PAM snippets in `assets/pam.d/`.
- Native plugin changes may require CMake and Nix package updates.
- Shell file moves may require `home/services/shell/default.nix` and package source sets to stay aligned.
