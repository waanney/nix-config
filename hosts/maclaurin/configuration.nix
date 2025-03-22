{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system.nix
      ../../modules/gnome.nix
    ];


# Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostName = "maclaurin";
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?

}
