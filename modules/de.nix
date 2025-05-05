{ config, lib, pkgs, ...}:
{
  services.displayManager.sddm.enable = true;
  programs.hyprland.enable = true;
  services.xserver.enable = true; 
  environment.systemPackages = with pkgs; [
    hyprpaper
    kitty
    rofi-wayland
    waybar
    btop
    nautilus
    neofetch
    brightnessctl
  ];
}
