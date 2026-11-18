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
      (let
        resetTouchpad = pkgs.writeShellScript "reset-ideapad-touchpad" ''
          set -eu
          touchpad=/sys/bus/i2c/devices/i2c-CMPL0001:00
          driver=/sys/bus/i2c/drivers/i2c_hid_acpi
          controller=/sys/bus/platform/devices/i2c_designware.0
          pci=/sys/bus/pci/devices/0000:00:15.0

          if [ ! -d "$touchpad" ] || [ ! -d "$driver" ]; then
            echo "IdeaPad CMPL0001:00 touchpad not found." >&2
            exit 1
          fi

          # Wake the controller before reprobe; leave unrelated I2C devices alone.
          printf 'on\n' > "$pci/power/control"
          printf 'on\n' > "$controller/power/control"
          if [ -L "$touchpad/driver" ]; then
            if [ "$(${pkgs.coreutils}/bin/readlink -f "$touchpad/driver")" != "$driver" ]; then
              echo "Unexpected touchpad driver; refusing to unbind it." >&2
              exit 1
            fi
            printf 'i2c-CMPL0001:00\n' > "$driver/unbind"
          fi
          ${pkgs.coreutils}/bin/sleep 1
          printf 'i2c-CMPL0001:00\n' > "$driver/bind"
          ${pkgs.systemd}/bin/udevadm settle --timeout=10
          test -L "$touchpad/driver"
          echo "Touchpad reinitialized."
        '';
      in
        pkgs.writeShellScriptBin "reset-touchpad" ''
          exec /run/wrappers/bin/sudo ${resetTouchpad}
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
