{
  description = "A Nix flake for reusable development shells and project templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    callTmpl = path: (import "${path}/flake.nix").outputs {inherit nixpkgs;};
  in {
    devShells.${system} = {
      web-dev = (callTmpl ./templates/web-dev).devShells.${system}.default;
      ai-dev = (callTmpl ./templates/ai-dev).devShells.${system}.default;
      rust-dev = (callTmpl ./templates/rust-dev).devShells.${system}.default;
      game-dev = (callTmpl ./templates/game-dev).devShells.${system}.default;
      latex-dev = (callTmpl ./templates/latex-dev).devShells.${system}.default;
      java-dev = (callTmpl ./templates/java-dev).devShells.${system}.default;
      cybersecurity-dev = (callTmpl ./templates/cybersecurity-dev).devShells.${system}.default;
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
        description = "LaTeX document writing shell with TeX Live and TexLab";
      };
      java-dev = {
        path = ./templates/java-dev;
        description = "Java development shell with JDK 21, Maven, and Gradle";
      };
      cybersecurity-dev = {
        path = ./templates/cybersecurity-dev;
        description = "Cybersecurity shell with pentesting tools and Pwntools";
      };
    };
  };
}
