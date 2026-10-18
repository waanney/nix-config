{ ... }: {
  xdg.desktopEntries.virtualbox = {
    name = "Oracle VM VirtualBox";
    genericName = "Virtual Machine";
    exec = "env QT_QPA_PLATFORM=xcb VirtualBox %U";
    terminal = false;
    type = "Application";
    icon = "virtualbox";
    comment = "Run several virtual systems on a single host computer";
    categories = [ "System" "Emulator" ];
    mimeType = [
      "application/x-virtualbox-vbox"
      "application/x-virtualbox-vbox-extpack"
      "application/x-virtualbox-ovf"
      "application/x-virtualbox-ova"
    ];
    settings = {
      "StartupWMClass" = "VirtualBox Manager";
    };
  };
}
