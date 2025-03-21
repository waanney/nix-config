{ config, lib, pkgs, ...}:
{

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kcolorchooser # color picker
    kdePackages.partitionmanager
    gparted
  ];
}
