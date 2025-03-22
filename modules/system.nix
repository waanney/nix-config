{config, pkgs, lib, ...}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.waanne = {
    isNormalUser = true;
    description = "waanne";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    zed-editor
    hyprland
    git
    ];
  };
  fonts.packages = with pkgs; [
    fira-code
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # setup default shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

  };
  # Install fcitx5 and unikey to type vietnamese language
  i18n.inputMethod = {
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

  #allow unfree
  nixpkgs.config.allowUnfree = true;
  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
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



}
