# Agent Checklists

## Before Editing

- Check `git status --short`.
- Read `docs/source-map.md` for source tree context.
- Inspect the relevant entrypoint files before changing leaf files.
- Identify existing user changes and avoid reverting them.

## Documentation Change

- Keep human Markdown under `docs/`.
- Keep agent Markdown under `.agents/`.
- Prefer ASCII Markdown.
- Check that no Markdown files exist outside `docs/` and `.agents/`.
- Verify no code files changed unless the task asked for code changes.

## Nix Change

- Follow existing module style.
- Keep reusable logic in shared modules instead of host-specific files when possible.
- Run `nix fmt` after edits.
- Prefer `sudo nixos-rebuild build --flake .#maclaurin` before switching.

## Shell Change

- Keep reusable UI in `components/`.
- Keep visible surfaces in `modules/`.
- Keep shared state in `services/`.
- Check QML imports when moving files.
- Verify compositor or shell IPC commands against the command syntax used by the target tool.
