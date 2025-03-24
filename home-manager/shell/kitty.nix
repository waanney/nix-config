{ config, pkgs, ... }:
{
  #packages for lsp, linter - nvim
  home.packages = with pkgs; [
  ];

  programs.kitty ={
      enable = true;
    };

  home.file = {
    ".config/kitty" = {
      source = ../../dotfiles/kitty;
      recursive = true;
    };
  };
}
