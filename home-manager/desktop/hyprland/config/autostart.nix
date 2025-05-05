

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/autostart.conf".text =''
#################
### AUTOSTART ###
#################


# exec-once = $terminal
# exec-once = nm-applet &
# exec-once = waybar & hyprpaper & firefox
exec-once = hyprpaper

  '';


}

