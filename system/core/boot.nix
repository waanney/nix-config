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
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
      "plymouth.use-simpledrm"
    ];

    loader = {
      # systemd-boot on UEFI
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;

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
