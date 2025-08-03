{pkgs,...}:{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix
    ./qt.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;
    seahorse.enable = true;
    adb.enable = true;
  };
  services.udev.packages = [pkgs.android-udev-rules];
}
