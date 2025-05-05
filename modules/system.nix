{config, pkgs, lib, ...}:
{
  # Define a user account. .
  users.users.waanne = {
    isNormalUser = true;
    description = "waanne";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    hyprland
    git
    ];
  };
  

  virtualisation.docker.enable = true;
  #Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];


  services.redis = {
    enable = true;
    bind = "127.0.0.1"; # Địa chỉ IP mà Redis sẽ lắng nghe
    port = 6379;        # Cổng mặc định
  };

  # Inputs and Outputs.
  services.printing.enable = true;                                  #print CUP
  services.xserver.xkb = { layout = "us"; variant = ""; };          #keyboard layout
  services.pulseaudio.enable = false;                               #Audio
  security.rtkit.enable = true;                                     #real time kit
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  #bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  # Enable networking
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;                                #allow unfree
  # setup default shell


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  # Location/ time
  time.timeZone = "Asia/Ho_Chi_Minh";
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
  #Nixos requirement
  nix.settings.experimental-features = [ "nix-command" "flakes" ];  # Enable the Flakes feature and the accompanying new nix command-line tool
  #Optimise!!!!!!
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
}
