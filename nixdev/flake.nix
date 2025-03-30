{
  description = "A Nix flake for web and AI development with shared Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
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
          neovim
          zsh
          starship
        ];
        shellHook = ''
          export SHELL=$(which zsh)
          echo "Welcome to the web development environment"
          exec $SHELL
        '';
      };

    # Môi trường shell cho phát triển AI
    devShells.x86_64-linux.ai-dev =
      pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          neovim
          zsh
          starship
          python312Packages.pandas
          python312
          python312Packages.numpy
          python312Packages.z3-solver
          python312Packages.jupyterlab
        ];
        shellHook = ''
          export SHELL=$(which zsh)
          echo "Welcome to the AI development environment"
          exec $SHELL
        '';
      };
  };
}

