{ config, pkgs, ... }:
{
  imports = [
   ./shell
   ./desktop
   ./utilities
 ];
  home.packages = with pkgs; [
    home-manager
  ];
  home.username = "waanne";
  home.homeDirectory = "/home/waanne";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
