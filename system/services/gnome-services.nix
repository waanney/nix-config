{pkgs, ...}: {
  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "waanne";
      };
    };
    desktopManager.gnome.enable = true;

    dbus.packages = with pkgs; [
      gcr_4
      gnome-settings-daemon
      libsecret
    ];

    gnome.gnome-keyring.enable = true;

    gvfs.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    gnome-contacts
    epiphany
    geary
  ];
}
