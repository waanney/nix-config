{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system.nix
      ../../modules/de.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   # Define your hostname.
  networking.hostName = "maclaurin";




  system.stateVersion = "24.11"; # Did you read the comment?

}
