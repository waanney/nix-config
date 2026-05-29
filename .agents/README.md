# .agents

This directory stores all AI-agent-facing Markdown for the repository.

## Contents

- `ai_toolkit/` - reusable prompts, checklists, and command notes.
- `ai_specs/` - task specs and implementation plan templates.
- `ai_docs/` - agent-oriented architecture notes and project context.

## How To Use This Directory

- Put durable agent rules in this README or in `ai_docs/`.
- Put task-specific implementation instructions in `ai_specs/`.
- Put reusable workflow material in `ai_toolkit/`.
- Put repo maps and context that help agents reason safely in `ai_docs/`.
- Put human-facing guides in `docs/`.

## Maintenance

Keep these files concise and specific to this repository. Agents can read source code directly, so this directory should focus on context, conventions, and safety rules that are easy to miss.

## Core Agent Rules

- Read `docs/source-map.md` before making broad changes.
- Check `git status --short` before editing.
- Do not touch unrelated dirty files.
- Use `rg` and `rg --files` for inspection.
- Use `apply_patch` for manual edits.
- For Nix changes, run `nix fmt` and prefer build/check commands before switching the live system.
- For shell changes, keep visible surfaces in `home/services/shell/modules/`, reusable UI in `components/`, shared state in `services/`, and typed configuration in `config/`.
