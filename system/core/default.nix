{lib, pkgs,...}: {
  imports = [
    ./security.nix
    ./users.nix
    ../nix
    # ../programs/fish.nix
    ../programs/nushell.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  console.keyMap = "la-latin1";

  # don't touch this
  system.stateVersion = lib.mkDefault "24.05";
  system = {
    switch.enable = true;
    rebuild.enableNg = true;
  };

    i18n.inputMethod = {                                              # Install fcitx5 and unikey to type vietnamese language
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
	    libsForQt5.fcitx5-unikey
      kdePackages.fcitx5-qt
	    fcitx5-unikey
   ];
  };

  time.hardwareClockInLocalTime = lib.mkDefault false;
  time.timeZone = "Asia/Ho_Chi_Minh";
  

  # compresses half the ram for use as swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
}
