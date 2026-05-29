# Development Templates

The `nixdev/` directory provides reusable development shells and flake templates.

## Available Templates

- `web-dev` - Node.js, Bun, Tailwind, and web tooling.
- `ai-dev` - Python, JupyterLab, FFmpeg, and AI tooling.
- `rust-dev` - Rust, rust-analyzer, clippy, and native build dependencies.
- `game-dev` - Godot and game development dependencies.
- `latex-dev` - TeX Live, latexmk, and TexLab.
- `java-dev` - JDK, Maven, and Gradle.
- `cybersecurity-dev` - pentesting tools and Pwntools.

## Enter a Template Shell

```bash
nix develop ./nixdev#web-dev
nix develop ./nixdev#ai-dev
```

## Initialize a New Project

```bash
nix flake init -t /etc/nixos/nixdev#web-dev
```

After initialization, enter the new project's shell with:

```bash
nix develop
```
