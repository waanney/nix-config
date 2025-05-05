

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/monitors.conf".text =''

################
### MONITORS ###
################

# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,2048x1280@120,auto,1


  '';


}

