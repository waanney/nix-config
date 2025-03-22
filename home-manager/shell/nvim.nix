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
  };
  home.file = {
  };
}
