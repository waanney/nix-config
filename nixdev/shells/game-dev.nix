{pkgs, ...}: pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    godot
    scons
    python312
    python312Packages.pip
    python312Packages.setuptools
    python312Packages.wheel
    python312Packages.black
    python312Packages.flake8
    # GDScript LSP support
    # Tools
    neovim
    nushell
    starship
    # Build tools (for compiling native extensions if needed)
    pkg-config
    gnumake
  ];
  shellHook = ''
    export SHELL=$(which nu)
    echo "Welcome to the Game development environment"
    echo "Godot 4 and Python 3.12 are available"
    exec $SHELL
  '';
}

