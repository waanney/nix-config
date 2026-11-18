{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    # load modules on boot
    kernelModules = ["v4l2loopback" "i2c-dev" "psmouse" "i2c_hid_acpi"];
    kernelPackages = pkgs.linuxPackages;
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [
      "ideapad_laptop.allow_v4_dytc=Y"
      # "usbcore.autosuspend=-1"

      "acpi_backlight=native"
      # Commented out - this parameter can prevent touchpad detection on some Ideapad models
      # "psmouse.synaptics_intertouch=1"
    ];
    kernel.sysctl = {
      # ZRAM & Virtual Memory optimization
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;

      "kernel.nmi_watchdog" = 0;
    };
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="OBS Virtual Output"
    '';
  };

  networking.hostName = "maclaurin";
  security.tpm2.enable = true;

  # RDP client for accessing newton's GNOME desktop over Tailscale.
  # The laptop only initiates connections; no incoming RDP ports are needed.
  environment.systemPackages = [
    pkgs.gnome-connections
    # Installer is not fetchable: add it to the store first with
    # nix-store --add-fixed sha256 CiscoPacketTracer_901_Ubuntu_64bit.deb
    pkgs.cisco-packet-tracer_9
  ];

  services = {
    oracleDatabase.enable = true;

    # CMPL0001:00 (06CB:CEFE) occasionally loses its DesignWare I2C bus.
    # Keep only this controller and its PCI parent out of runtime suspend;
    # normal system suspend is still available.
    udev.extraRules = ''
      ACTION=="add|bind|change", SUBSYSTEM=="pci", KERNEL=="0000:00:15.0", ATTR{vendor}=="0x8086", ATTR{device}=="0x7e78", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add|bind|change", SUBSYSTEM=="platform", KERNEL=="i2c_designware.0", TEST=="power/control", ATTR{power/control}="on"
    '';

    # for SSD/NVME
    fstrim.enable = true;
    scx.enable = true;
    scx.scheduler = "scx_rusty";
  };
}
