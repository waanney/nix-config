{ config, pkgs, ... }:
{
  imports = [
   ./shell
   ./desktop
   ./utilities
 ];
  home.username = "waanne";
  home.homeDirectory = "/home/waanne";



  home.stateVersion = "24.11";
  home.packages = [];
  home.file = {};
  home.sessionVariables = {};
  programs.home-manager.enable = true;
}
