{pkgs, ...}: {
  services = {
    printing.enable = true;

    dbus.implementation = "broker";
    blueman.enable = true;

    irqbalance.enable = true;

    # Protect system from freeze on high RAM pressure
    earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 4;
      freeSwapThreshold = 5;
    };
  };
  # Use in place of hypridle's before_sleep_cmd, since systemd does not wait for
  # it to complete

  services.ntp.enable = true;
  powerManagement = {
    enable = true;
    powerDownCommands = ''
      # Lock all sessions
      loginctl lock-sessions

      # Wait for lockscreen(s) to be up
      sleep 1

      # Unload touchpad driver BEFORE sleep to prevent I2C state corruption
      ${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi
    '';
    resumeCommands = ''
      # Give the I2C bus time to wake up, then load the driver
      sleep 1
      ${pkgs.kmod}/bin/modprobe i2c_hid_acpi
    '';
  };

  systemd.services.reload-touchpad-boot = {
    description = "Reload Touchpad Driver on Boot";
    wantedBy = [ "multi-user.target" ];
    before = [ "display-manager.service" ];
    script = ''
      ${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi
      sleep 1
      ${pkgs.kmod}/bin/modprobe i2c_hid_acpi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
