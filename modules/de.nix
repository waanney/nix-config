{ config, lib, pkgs, ...}:
{

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  programs.hyprland.enable = true;
    # Enable the X11 windowing system.
  services.xserver.enable = true; 
  environment.systemPackages = with pkgs; [
    hyprpaper
    kitty
    rofi-wayland
    waybar
  ];


}
