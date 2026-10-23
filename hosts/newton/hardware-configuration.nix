# Hardware configuration for the current newton system.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # TeamGroup NV5000 NVMe + USB
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules  = [];
  boot.kernelModules         = ["kvm-intel"];
  boot.extraModulePackages   = [];

  # ── File Systems ──────────────────────────────────────────────────────────
  # UUIDs from the existing installed system.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4b3cb437-923a-48a0-a6c5-14a28e0ca484";
    fsType = "ext4";
    options = ["noatime" "nodiratime"]; # tối ưu NVMe
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/65D1-B44A";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  # 32GB RAM → không cần swap vật lý (zramSwap từ system/core/default.nix)
  swapDevices = [];

  # ── Platform ──────────────────────────────────────────────────────────────
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform               = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
