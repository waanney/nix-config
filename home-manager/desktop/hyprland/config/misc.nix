

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/misc.conf".text =''
# https://wiki.hyprland.org/Configuring/Variables/#misc
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    initial_workspace_tracking = 1
}

  '';


}

