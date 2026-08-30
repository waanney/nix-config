# Development Templates

The `nixdev/` directory provides reusable development shells and flake templates registered under `dev#`.

## Available Templates

- `web-dev` - Node.js, Bun, Tailwind, and web tooling.
- `ai-dev` - Python, JupyterLab, FFmpeg, and AI tooling.
- `rust-dev` - Rust, rust-analyzer, clippy, and native build dependencies.
- `game-dev` - Godot and game development dependencies.
- `latex-dev` - TeX Live (with Vietnamese support), latexmk, and TexLab.
- `java-dev` - JDK, Maven, and Gradle.
- `cybersecurity-dev` - pentesting tools and Pwntools.

## Quick Usage with Zsh Helper

List all templates:

```bash
dev list
```

Enter any development shell:

```bash
dev latex-dev
dev rust-dev
dev web-dev
```

Initialize a new project from a template:

```bash
mkdir my-project && cd my-project
devinit latex-dev
```

## Native Nix Commands (via `dev#` Registry)

Enter a development shell:

```bash
nix develop dev#latex-dev
```

Initialize a project from a template:

```bash
nix flake init -t dev#latex-dev
```
