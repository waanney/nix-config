# ⚠️  TEMPLATE — Cần thay UUID thật bằng cách chạy:
#    nixos-generate-config --root /mnt   (khi cài fresh)
#    hoặc: blkid                          (trên hệ thống đã cài)
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
  # ⚠️  REPLACE với UUID thật từ `blkid` hoặc `nixos-generate-config`
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-ROOT-UUID";
    fsType = "ext4";
    options = ["noatime" "nodiratime"]; # tối ưu NVMe
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-BOOT-UUID";
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
