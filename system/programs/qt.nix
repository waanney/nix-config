{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs; [hicolor-icon-theme];
}
