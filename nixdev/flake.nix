{
  description = "A Nix flake for web and AI development with shared Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    web-dev-template.url = "path:./templates/web-dev";
    ai-dev-template.url = "path:./templates/ai-dev";
    rust-dev-template.url = "path:./templates/rust-dev";
    game-dev-template.url = "path:./templates/game-dev";
    latex-dev-template.url = "path:./templates/latex-dev";
  };

  outputs = {self, nixpkgs, web-dev-template, ai-dev-template, rust-dev-template, game-dev-template, latex-dev-template, ... }:
  let
    system = "x86_64-linux";
    templateShell = tmpl: tmpl.devShells.${system}.default;
  in {
    devShells.${system} = {
      web-dev = templateShell web-dev-template;
      ai-dev = templateShell ai-dev-template;
      rust-dev = templateShell rust-dev-template;
      game-dev = templateShell game-dev-template;
      latex-dev = templateShell latex-dev-template;
    };

    templates = {
      default = self.templates.web-dev;
      web-dev = {
        path = ./templates/web-dev;
        description = "Web development shell with Node.js/Bun/Tailwind tooling";
      };
      ai-dev = {
        path = ./templates/ai-dev;
        description = "AI/ML shell with Python 3.12, JupyterLab, and FFmpeg";
      };
      rust-dev = {
        path = ./templates/rust-dev;
        description = "Rust shell with rust-analyzer, clippy, and OpenSSL";
      };
      game-dev = {
        path = ./templates/game-dev;
        description = "Game dev shell with Godot 4, Python tooling, and build deps";
      };
      latex-dev = {
        path = ./templates/latex-dev;
        description = "Game dev shell with Godot 4, Python tooling, and build deps";
      };
    };
  };
}

