{ config, pkgs, ... }:
{
  imports = [
   ./nvim.nix
 ];
  home.packages = with pkgs; [
  ];

  programs.git = {
    enable = true;
    userName = "waanney";
    userEmail = "work.buiminhquan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
  };

  programs.kitty ={
    enable = true;
  };

  programs.starship = {
    enable = true;
  };
  home.file = {
    ".config/kitty" = {
      source = ./.kitty;
      recursive = true;
    };
    ".zshrc" = {
      source = ./.zshrc;
    };
  };
}
