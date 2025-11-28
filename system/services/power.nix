{
  services = {
    logind = {
      settings = {
        Login = {
          HandlePowerKey = "suspend";
          HandleLidSwitch = "suspend";
          HandleLidSwitchExternalPower = "lock";
        };
      };
    };
    
    power-profiles-daemon.enable = true;

    # battery info
    upower = {
      enable = true;
      percentageLow = 30;
      percentageCritical = 20;
      percentageAction = 10;
      criticalPowerAction = "Hibernate";
    };
  };
}
