

{ config, pkgs, ... }:
{

  home.file.".config/hypr/hyprland.conf".text =''
# Animation
source = ~/.config/hypr/config/animation.conf

#Autostart
source = ~/.config/hypr/config/autostart.conf

# Cursor
source = ~/.config/hypr/config/cursor.conf

# Decoration
source = ~/.config/hypr/config/decoration.conf

#Environment
source = ~/.config/hypr/config/environment.conf

#Keybinding
source = ~/.config/hypr/config/keybindings.conf

#Keyboard
source = ~/.config/hypr/config/keyboard.conf

# Layout
source = ~/.config/hypr/config/layout.conf

#misc
source = ~/.config/hypr/config/misc.conf

#Monitor
source = ~/.config/hypr/config/monitors.conf

#window rules
source = ~/.config/hypr/config/windowrules.conf

# Windows layour
source = ~/.config/hypr/config/windows.conf



  '';


}

