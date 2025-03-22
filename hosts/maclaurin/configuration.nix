{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system.nix
      ../../modules/gnome.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   # Define your hostname.
  networking.hostName = "maclaurin";


  # Enable the X11 windowing system.
  services.xserver.enable = true;



  system.stateVersion = "24.11"; # Did you read the comment?

}
