{pkgs, ...}: {
  home.packages = with pkgs; [
    anydesk
    xwayland
  ];

  xdg.desktopEntries.anydesk = {
    name = "AnyDesk";
    exec = "env DISPLAY=:0 GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb anydesk";
    terminal = false;
    type = "Application";
    icon = "anydesk";
    comment = "AnyDesk Remote Desktop";
    categories = ["Network" "RemoteAccess"];
    settings = {
      "StartupWMClass" = "anydesk";
    };
  };
}

