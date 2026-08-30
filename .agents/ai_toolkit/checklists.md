# Agent Checklists

## Before Editing

- Check `git status --short`.
- Read `docs/source-map.md` for source tree context.
- Inspect the relevant entrypoint files before changing leaf files.
- Identify existing user changes and avoid reverting them.

## Documentation Change

- Keep human Markdown under `docs/`.
- Keep agent Markdown under `.agents/`.
- Maintain ASCII Markdown formatting.
- Check that no Markdown files exist outside `docs/`, `.agents/`, and `tests/`.
- Verify no code files changed unless the task asked for code changes.

## Nix Change

- Follow existing module style and single-responsibility layout.
- Keep reusable logic in shared modules instead of host-specific files when possible.
- Run `nix fmt` after edits.
- Run `nix flake check --no-build` to verify syntax and flake schema compliance.
- Recommend `nh os switch /etc/nixos` (or `sudo nixos-rebuild build --flake .#maclaurin`) for building/switching.

## Shell & UI Change

- Keep reusable UI widgets in `components/`.
- Keep lightweight, non-blocking metrics in `sysinfo.sh`.
- Avoid polling intervals below 200ms in QML Timers.
- Verify compositor or shell IPC commands against Niri syntax (`niri msg action ...`).
