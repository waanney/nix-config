{
  description = "Godot + Python powered game development shell template";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    shell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        godot
        scons
        python312
        python312Packages.pip
        python312Packages.setuptools
        python312Packages.wheel
        python312Packages.black
        python312Packages.flake8
        neovim
        nushell
        starship
        pkg-config
        gnumake
      ];
      shellHook = ''
        export SHELL=$(which nu)
        echo "Welcome to the Game development environment"
        echo "Godot 4 and Python 3.12 are available"
      '';
    };
  in {
    devShells.${system} = {
      default = shell;
      game-dev = shell;  -- Allow nix develop .#game-dev in template directory
    };
  };
}



