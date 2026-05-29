# Documentation Reorganization Spec

## Goal

Group Markdown documentation under two roots:

- `docs/` for human-facing documentation.
- `.agents/` for AI-agent-facing context, specs, and workflow material.

## Scope

- Remove Markdown files from source folders.
- Remove root-level Markdown entrypoints.
- Keep consolidated documentation indexes in `docs/` and `.agents/`.
- Preserve useful context from folder READMEs in `docs/source-map.md` and `.agents/ai_docs/`.

## Out Of Scope

- Runtime code changes.
- Nix module changes.
- QML shell behavior changes.
- Fixing unrelated existing dirty files.

## Acceptance Criteria

- All remaining Markdown files live under `docs/` or `.agents/`.
- No source folder contains a local `README.md`.
- Human documentation is discoverable from `docs/README.md`.
- Agent documentation is discoverable from `.agents/README.md`.

## Verification

```bash
rg --hidden --files -g '*.md' -g '!.git/**' -g '!.codex/**' | sort
find . -path ./.git -prune -o -path ./.codex -prune -o -path ./.agents -prune -o -path ./docs -prune -o -name '*.md' -print
git status --short
```
