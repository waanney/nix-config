{ config, lib, pkgs, ...}:
{

  services.displayManager.sddm.enable = true;
  programs.hyprland.enable = true;
    # Enable the X11 windowing system.
  services.xserver.enable = true; 
  environment.systemPackages = with pkgs; [
    hyprpaper
    kitty
    rofi-wayland
    waybar
    htop
    nautilus
  ];


}
