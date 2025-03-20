{ config, pkgs, ... }:
{
  home.username = "waanne";
  home.homeDirectory = "/home/waanne";

  programs.git = {
    enable = true;
    userName = "waanney";
    userEmail = "work.buiminhquan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "24.11";
  home.packages = [];
  home.file = {};
  home.sessionVariables = {};
  programs.home-manager.enable = true;
}
