{pkgs, ...}: {
  services = {
    printing.enable = true;

    dbus.implementation = "broker";
    blueman.enable = true;

    # profile-sync-daemon
    psd = {
      enable = true;
      resyncTimer = "10m";
    };
    irqbalance.enable = true;
  };
  programs.dconf.enable = true;

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
    '';
  };

  systemd.services.reload-touchpad = {
    description = "Reload Touchpad Driver on Boot and Resume";
    wantedBy = ["multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    after = ["multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    script = ''
      sleep 2
      ${pkgs.kmod}/bin/modprobe -r i2c_hid_acpi
      sleep 1
      ${pkgs.kmod}/bin/modprobe i2c_hid_acpi
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
