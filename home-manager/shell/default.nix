{ config, pkgs, ... }:
{
  imports = [
    ./neovim
    ./kitty.nix
    ./git.nix
    ./zshrc.nix
    ./starship.nix

 ];
  home.packages = with pkgs; [
    gh
    vscode
  ];

  home.file = {
    ".config/waybar" = {
      source = ../../dotfiles/waybar;
    };
  };
}
