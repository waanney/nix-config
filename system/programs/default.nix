{pkgs, ...}: {
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
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    # adb.enable = true;
  };
}
