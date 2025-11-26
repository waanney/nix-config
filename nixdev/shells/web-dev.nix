{pkgs, ...}: pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    nodejs
    bun
    yarn
    pnpm
    neovim
    nushell
    starship
    # LSP
    tailwindcss-language-server
  ];
  shellHook = ''
    export SHELL=$(which nu)
    echo "Welcome to the web development environment"
    exec $SHELL
  '';
}

