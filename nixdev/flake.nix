{
  description = "A Nix flake for web and AI development with shared Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # Môi trường shell cho phát triển web
    devShells.x86_64-linux.web-dev =
      pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nodejs
          yarn
          pnpm
          neovim
          nushell
          starship
          #LSP
          tailwindcss-language-server
        ];
        shellHook = ''
          export SHELL=$(which nu)
          echo "Welcome to the web development environment"
          exec $SHELL
        '';
      };

    # Môi trường shell cho phát triển AI
    devShells.x86_64-linux.ai-dev =
      pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          neovim
          nushell
          starship
          gcc
          python312Packages.tkinter
          python312Packages.pandas
          python312Packages.stdenv
          python312
          python312Packages.pip
          python312Packages.flake8
          python312Packages.black
          python312Packages.numpy
          python312Packages.z3-solver
          python312Packages.jupyterlab
          python312Packages.python-dotenv
          python312Packages.uv
        ];
        shellHook = ''
          export SHELL=$(which nu)
          echo "Welcome to the AI development environment"
          exec $SHELL
        '';
      };
  };
}
