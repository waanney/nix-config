{
  config,
  pkgs,
  ...
}: {
  boot = {
    bootspec.enable = true;
    

    initrd = {
      systemd.enable = true;
    };
    supportedFilesystems = ["ntfs"];


    consoleLogLevel = 3;
    kernelParams = [
    ];

    loader = {
      # systemd-boot on UEFI
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };


    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };
  systemd.services.nix-daemon = {
    environment = {
      TMPDIR = "/var/tmp";
    };
  };
  environment.systemPackages = [config.boot.kernelPackages.cpupower];
}
