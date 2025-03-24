{ config, pkgs, ... }:
{
  #packages for lsp, linter - nvim
  home.packages = with pkgs; [
    wl-clipboard
    gh
    fd
  ];
  programs.neovim = {

    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [ pkgs.vimPlugins.nvim-treesitter ];
    extraPackages = [
      pkgs.nodePackages_latest.vscode-json-languageserver
      pkgs.ripgrep
    ];

  };
  home.file = {
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
  };
}
