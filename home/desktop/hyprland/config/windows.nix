

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/windows.conf".text =''

# -----------------------------------------------------
# General window layout and colors
# name: "Default"
# -----------------------------------------------------

general {
    gaps_in = 10
    gaps_out = 14
    border_size = 3
    col.active_border = rgba(36,56,131,1.0)
    col.inactive_border = rgba(ffffffff)
    layout = dwindle
    resize_on_border = true
}

  '';


}

