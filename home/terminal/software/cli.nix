{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # archives
      zip
      unzip
      unrar

      # misc
      libnotify
      fontconfig

      # utils
      dust
      duf
      fd
      file
      jaq
      ripgrep
      killall
      jq

      # SSH/remote
      mosh

      discordo
      fum
      glow
      gtt
      meteor-git
      reddit-tui
      scope-tui
      tuicam
      wiremix
      zfxtop
      nix-search-tv
      television

      gdb
      (pkgs.writeShellScriptBin "reset-touchpad" ''
        echo "Resetting touchpad drivers..."
        # Ignore errors if some modules are built-in or not loaded
        sudo rmmod i2c_hid_acpi i2c_hid i2c_designware_platform i2c_designware_core 2>/dev/null || true
        sudo modprobe i2c_designware_core 2>/dev/null || true
        sudo modprobe i2c_designware_platform 2>/dev/null || true
        sudo modprobe i2c_hid 2>/dev/null || true
        sudo modprobe i2c_hid_acpi 2>/dev/null || true
        echo "Done."
      '')

    ]
    ++ (with inputs.mynixpkgs.packages.${pkgs.stdenv.hostPlatform.system}; [
      opencode
      bmm
      omm
      prs
      dfft
      crush
    ]);

  programs = {
    eza.enable = true;
    ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          ForwardAgent = false;
          Compression = true;
          ControlMaster = "auto";
          ControlPath = "~/.ssh/master-%r@%h:%p";
          ControlPersist = "10m";
        };
        "100.104.251.17" = {
          HostName = "100.104.251.17";
          User = "ngphuoc";
        };
        "server-old" = {
          HostName = "103.73.232.250";
          User = "root";
          Port = 17022;
          IdentityFile = "~/.ssh/id_rsa";
        };
        "vps247" = {
          HostName = "103.73.232.247";
          User = "root";
          Port = 56107;
          IdentityFile = "~/.ssh/id_rsa_tho";
        };
        "vps241" = {
          HostName = "156.67.214.241";
          User = "root";
          IdentityFile = "~/.ssh/id_rsa";
        };
        "vps255" = {
          HostName = "103.73.232.255";
          User = "root";
          Port = 15894;
          IdentityFile = "~/.ssh/id_rsa";
        };
        "schooluxR" = {
          HostName = "157.230.247.139";
          User = "team2reader";
        };
        "schooluxW" = {
          HostName = "178.128.20.226";
          User = "root";
        };
      };
    };
    dircolors = {
      enable = true;
      # enableNushellIntegration = true;
    };
  };
}
