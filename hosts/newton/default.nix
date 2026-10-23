{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./ros2.nix
  ];

  # ─── Bootloader & Kernel ────────────────────────────────────────────────────
  boot = {
    # Intel i5-14600KF (Raptor Lake), NVIDIA RTX 5080
    kernelModules = [
      "v4l2loopback"
      "i2c-dev"
      "kvm-intel"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
    };

    kernelParams = [
      # Intel CPU — active P-state scaling
      "intel_pstate=active"

      # NVIDIA DRM KMS (bắt buộc cho Wayland / GDM)
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    kernel.sysctl = {
      # Desktop: swappiness thấp (32GB RAM, NVMe nhanh)
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;

      # Tăng buffer mạng — hữu ích cho ROS DDS
      "net.core.rmem_max" = 2147483647;
      "net.core.wmem_max" = 2147483647;
      "net.core.rmem_default" = 1048576;
      "net.core.wmem_default" = 1048576;
    };

    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Output"
    '';
  };

  # ─── Network ────────────────────────────────────────────────────────────────
  networking.hostName = "newton";

  # Reach GNOME RDP over the private Tailscale network, not public/LAN ports.
  # 3389 is Remote Login; Desktop Sharing can use 3390 when both are enabled.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [3389 3390];

  # ─── Time / Clock ───────────────────────────────────────────────────────────
  # Chỉ NixOS, không dual boot Windows → dùng UTC chuẩn
  time.hardwareClockInLocalTime = lib.mkForce false;

  # ─── Services ───────────────────────────────────────────────────────────────
  # Restore GPU memory correctly on manual suspend/resume. Driver 595+ with
  # nvidia-open supports kernel notifications instead of the legacy services.
  # Keep this host-specific; the laptop has a separate power policy.
  hardware.nvidia = {
    powerManagement = {
      enable = lib.mkForce true;
      kernelSuspendNotifier = true;
    };
    # The RTX 5080 has 16 GiB VRAM: use the SSD, not the small /tmp tmpfs.
    moduleParams.nvidia.NVreg_TemporaryFilePath = "/var/tmp";
  };

  services = {
    # Keep GNOME/Wayland. Configure TLS and credentials in GNOME Settings;
    # never put remote-access passwords in the world-readable Nix store.
    gnome.gnome-remote-desktop.enable = true;

    # This host has no identity for the laptop's encrypted Oracle password.
    oracleDatabase.enable = false;

    # NVMe TRIM (TeamGroup NV5000)
    fstrim.enable = true;

    # CPU scheduler tối ưu cho desktop (latency-aware, tốt hơn scx_rusty trên desktop)
    scx.enable = true;
    scx.scheduler = "scx_lavd";

    # Udev rules cho các thiết bị engineering (KiCad, v.v.)
    udev.packages = with pkgs; [
      openocd
      platformio-core
    ];
  };

  # Make Remote Login available after boot, including at the GDM login screen.
  # RDP itself stays disabled until explicitly configured in GNOME Settings.
  systemd.services.gnome-remote-desktop.wantedBy = ["graphical.target"];

  # ─── Packages ───────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  system.build.isaacsimUnwrapped = pkgs.callPackage "${inputs.isaac-sim}/isaacsim/isaacsim.nix" {
    extraLibs = with pkgs; [zlib libuuid libxcrypt-legacy libnsl libtirpc];
    # The standalone Kit/Python executables also need the NixOS ELF loader,
    # before upstream wraps them with the simulator's environment.
    patchExtra = [
      "kit/kit"
      "kit/kit-gcov"
      "kit/python/python"
      "kit/python/python3"
      "kit/python/bin/python3"
      "kit/python/bin/python3.12"
    ];
  };

  system.build.isaacsim = pkgs.symlinkJoin {
    name = "isaacsim-${config.system.build.isaacsimUnwrapped.version}-with-ca";
    paths = [config.system.build.isaacsimUnwrapped];
    nativeBuildInputs = [pkgs.makeWrapper];
    inherit (config.system.build.isaacsimUnwrapped) version meta;
    # Kit's bundled Python/OpenSSL otherwise looks for /etc/ssl/cert.pem,
    # which is not the NixOS CA bundle location. Wrap only the entry points
    # so certificate fixes do not recopy the large simulator installation.
    postBuild = ''
      for executable in isaacsim isaacsim-kit isaacsim-python; do
        wrapProgram "$out/bin/$executable" \
          --set-default SSL_CERT_FILE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
          --set-default CURL_CA_BUNDLE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
          --set-default REQUESTS_CA_BUNDLE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      done
    '';
  };

  environment.systemPackages = with pkgs; [
    config.system.build.isaacsim

    # ── 3D / CAD / Engineering ──────────────────────────────────────────────
    blender
    freecad-wayland
    kicad
    orca-slicer

    # ── Remote access ────────────────────────────────────────────────────────
    anydesk

    # ── System / Debug ───────────────────────────────────────────────────────
    lm_sensors
    pciutils
    usbutils
    hw-probe
  ];
}
