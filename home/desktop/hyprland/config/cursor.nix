

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/cursor.conf".text =''
exec-once = hyprctl setcursor Bibata-Modern-Ice 24

# No Hardware Cursor
cursor {
    no_hardware_cursors = true
}

  '';


}

