{pkgs, ...}: pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    neovim
    nushell
    starship
    # Build tools
    pkg-config
    openssl
  ];
  shellHook = ''
    export SHELL=$(which nu)
    echo "Welcome to the Rust development environment"
    exec $SHELL
  '';
}

