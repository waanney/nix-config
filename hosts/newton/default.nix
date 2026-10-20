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

  # ─── Time / Clock ───────────────────────────────────────────────────────────
  # Chỉ NixOS, không dual boot Windows → dùng UTC chuẩn
  time.hardwareClockInLocalTime = lib.mkForce false;

  # ─── Services ───────────────────────────────────────────────────────────────
  services = {
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

  # ─── Packages ───────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
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
