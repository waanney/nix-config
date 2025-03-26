{ inputs,system ,config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system.nix
      ../../modules/de.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "maclaurin";
  
  home-manager = {
    extraSpecialArgs = { inherit inputs system;};
    users = {
      waanne = import ../../home-manager/home.nix;
    };

  };



  system.stateVersion = "24.11"; # Did you read the comment?

}
