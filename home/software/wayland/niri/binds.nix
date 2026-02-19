{
  config,
  pkgs,
  ...
}: {
  programs.niri.settings.binds = with config.lib.niri.actions; let
    set-volume = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@";
    brightness = action: spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" action;
    playerctl = spawn "${pkgs.playerctl}/bin/playerctl";
  in {
    "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
    "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";

    "XF86AudioPlay".action = playerctl "play-pause";
    "XF86AudioStop".action = playerctl "pause";
    "XF86AudioPrev".action = playerctl "previous";
    "XF86AudioNext".action = playerctl "next";

    "XF86AudioRaiseVolume".action = set-volume "5%+";
    "XF86AudioLowerVolume".action = set-volume "5%-";

    "XF86MonBrightnessUp".action = brightness "+10%";
    "XF86MonBrightnessDown".action = brightness "10%-";

    "Print".action.screenshot-screen = {write-to-disk = true;};
    "Mod+Shift+Alt+S".action.screenshot-window = {write-to-disk = true;};
    "Mod+Shift+S".action.screenshot = {show-pointer = false;};
    "Mod+Space".action = spawn "${pkgs.rofi}/bin/rofi" "-show";
    "Mod+Return".action = spawn "${pkgs.wezterm}/bin/wezterm";
    "Ctrl+Alt+L".action = spawn "sh -c 'pgrep hyprlock || hyprlock'";

    "Mod+U".action = spawn "env XDG_CURRENT_DESKTOP=gnome gnome-control-center";

    "Mod+Q".action = close-window;
    "Mod+S".action = switch-preset-column-width;
    "Mod+F".action = maximize-column;

    "Mod+1".action = set-column-width "25%";
    "Mod+2".action = set-column-width "50%";
    "Mod+3".action = set-column-width "75%";
    "Mod+4".action = set-column-width "100%";
    # "Mod+Shift+F".action = fullscreen-window;
    "Mod+Shift+F".action = expand-column-to-available-width;
    "Mod+D".action = toggle-window-floating;
    "Mod+W".action = toggle-column-tabbed-display;

    "Mod+Comma".action = consume-window-into-column;
    "Mod+Period".action = expel-window-from-column;
    "Mod+C".action = center-visible-columns;
    "Mod+Tab".action = switch-focus-between-floating-and-tiling;

    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Plus".action = set-column-width "+10%";
    "Mod+Shift+Minus".action = set-window-height "-10%";
    "Mod+Shift+Plus".action = set-window-height "+10%";

    "Mod+H".action = focus-column-left;
    "Mod+L".action = focus-column-right;
    "Mod+J".action = focus-window-or-workspace-down;
    "Mod+K".action = focus-window-or-workspace-up;
    "Mod+Left".action = focus-column-left;
    "Mod+Right".action = focus-column-right;
    "Mod+Down".action = focus-workspace-down;
    "Mod+Up".action = focus-workspace-up;

    "Mod+Shift+H".action = move-column-left;
    "Mod+Shift+L".action = move-column-right;
    "Mod+Shift+K".action = move-column-to-workspace-up;
    "Mod+Shift+J".action = move-column-to-workspace-down;

    "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
    "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;

    # Workspace navigation - chuyển nhanh giữa các named workspace
    "Mod+Alt+1".action.focus-workspace = "communication";
    "Mod+Alt+2".action.focus-workspace = "development";
    "Mod+Alt+3".action.focus-workspace = "browsing";
    "Mod+Alt+4".action.focus-workspace = "media";

    # Di chuyển cửa sổ hiện tại sang workspace khác
    "Mod+Shift+Alt+1".action.move-column-to-workspace = "communication";
    "Mod+Shift+Alt+2".action.move-column-to-workspace = "development";
    "Mod+Shift+Alt+3".action.move-column-to-workspace = "browsing";
    "Mod+Shift+Alt+4".action.move-column-to-workspace = "media";
  };
}
