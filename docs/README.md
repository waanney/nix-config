# docs

This directory stores all human-facing Markdown documentation for the NixOS and Home Manager configuration.

## Contents

- `overview.md` - high-level explanation of how the repository is organized.
- `operations.md` - common maintenance, build, and rebuild workflows.
- `source-map.md` - grouped map of the source tree after removing folder-level READMEs.
- `templates.md` - how to use the development shell templates in `nixdev/`.

## Documentation Policy

- Use this folder for guides meant to be read by people.
- Keep AI-agent-specific rules and implementation specs in `.agents/`.
- Do not add Markdown files back into source folders unless the documentation model changes.
- Prefer commands that build or check before commands that switch the live system.
