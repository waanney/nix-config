

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/keybindings.conf".text =''
$mainMod = SUPER # Sets "Windows" key as main modifier
$terminal = kitty
$fileManager = nautilus
$menu = pkill rofi || rofi -show drun -replace -i -show-icons 
$browser = zen





#Application
bind = $mainMod, RETURN, exec, $terminal
bind = $mainMod, B, exec, $browser
bind = $mainMod, E, exec, $fileManager
bind = $mainMod SHIFT, W, exec, pkill waybar || waybar
bind = $mainMod SHIFT, S, exec, hyprshot -m region
#Windows
bind = $mainMod, Q, killactive,
bind = $mainMod SHIFT, Q, exec, hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill
bind = $mainMod, F, fullscreen, 0
bind = $mainMod, M, fullscreen, 1
bind = $mainMod, T, togglefloating 
bind = $mainMod, R, exec, $menu
bind = $mainMod, J, togglesplit, # dwindle


bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
bind = $mainMod SHIFT, right, resizeactive, 100 0         # Increase window width with keyboard
bind = $mainMod SHIFT, left, resizeactive, -100 0         # Reduce window width with keyboard
bind = $mainMod SHIFT, down, resizeactive, 0 100         # Increase window height with keyboard
bind = $mainMod SHIFT, up, resizeactive, 0 -100 
bind = $mainMod ALT, left, swapwindow, l                  # Swap tiled window left
bind = $mainMod ALT, right, swapwindow, r                 # Swap tiled window right
bind = $mainMod ALT, up, swapwindow, u                    # Swap tiled window up
bind = $mainMod ALT, down, swapwindow, d              # Swap tiled window down
binde = ALT,Tab,cyclenext                               # Cycle between windows
binde = ALT,Tab,bringactivetotop
#Actions
bind = $mainMod ALT, M, exit,

#Workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

bind = $mainMod, Tab, workspace, m+1       # Open next workspace
bind = $mainMod SHIFT, Tab, workspace, m-1 # Open previous workspace

bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1
bind = $mainMod CTRL, down, workspace, empty # Open the next empty workspace


# Laptop multimedia keys for volume and LCD brightness
bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 3%+
bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 3%-

# Requires playerctl
bindl = , XF86AudioNext, exec, playerctl next
bindl = , XF86AudioPause, exec, playerctl play-pause
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous


  '';


}

