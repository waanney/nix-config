{ config, pkgs, ... }:
{
  # Packages for LSP, linter - Neovim
  home.packages = with pkgs; [
    wl-clipboard
    gh
    fd
    python3
    wget
    nodejs
    ripgrep # Thêm rigrep
    #LSP
    clang-tools
    lua-language-server
    stylua
    nil
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter # treesitter
    ];

    # extraPackages không cần thiết ở đây, các gói đã được thêm vào home.packages.
    # extraPackages = [
    #   pkgs.nodePackages_latest.vscode-json-languageserver
    #   pkgs.ripgrep
    # ];
  };

  home.file = {
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
  };
}
