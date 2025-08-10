{ pkgs, ... }: {
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        "org.freedesktop.impl.portal.Screenshot" = "gnome";
        "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
      };
      wlr = {
        enable = "true";  # Make sure this is a string
        settings = [
          # You might just want to pass a string with the necessary information
          "screencast-chooser-cmd=/nix/store/jh9zgnz2xflqz2fjgi7d4x8779m9s8iw-slurp-1.5.0/bin/slurp -f %o -or"
        ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
    ];
  };
}
