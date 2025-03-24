{ config, pkgs, ... }:
{
  imports = [
    ./neovim.nix
    ./kitty.nix

 ];
  home.packages = with pkgs; [
    gh
  ];

  programs.git = {
    enable = true;
    userName = "waanney";
    userEmail = "work.buiminhquan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.starship = {
    enable = true;
  };
  home.file = {
    
    ".config/hypr" = {
      source = ../../dotfiles/hyprland;
    };
    ".zshrc" = {
      source = ./.zshrc;
    };
  };
}
