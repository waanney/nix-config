_: {
  # nh default flake
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    # weekly cleanup
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d";
    };
  };
}
