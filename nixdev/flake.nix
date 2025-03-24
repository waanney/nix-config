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
        ];
        shellHook = ''
          echo "Welcome to the web development environment"
        '';
      };

    # Môi trường shell cho phát triển AI
    devShells.x86_64-linux.ai-dev =
      pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          neovim
          python312
          python312Packages.numpy
          python312Packages.pandas
          python312Packages.scikit-learn
          python312Packages.tensorflow
        ];
        shellHook = ''
          echo "Welcome to the AI development environment"
        '';
      };
  };
}

