{ config, lib, pkgs, ...}:
{

  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

}
