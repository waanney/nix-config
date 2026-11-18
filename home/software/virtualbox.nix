{pkgs, ...}: let
  virtualboxLauncher = pkgs.writeShellScriptBin "VirtualBox" ''
    # Qt's GTK file chooser needs GTK 3 schemas, which GNOME's GTK 4
    # session does not export. VM processes inherit this environment too.
    export XDG_DATA_DIRS="${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}''${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}"
    export QT_QPA_PLATFORM=xcb
    exec /run/current-system/sw/bin/VirtualBox "$@"
  '';
in {
  home.packages = [virtualboxLauncher];

  xdg.desktopEntries.virtualbox = {
    name = "Oracle VM VirtualBox";
    genericName = "Virtual Machine";
    exec = "${virtualboxLauncher}/bin/VirtualBox %U";
    terminal = false;
    type = "Application";
    icon = "virtualbox";
    comment = "Run several virtual systems on a single host computer";
    categories = ["System" "Emulator"];
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
