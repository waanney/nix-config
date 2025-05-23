

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/keyboard.conf".text =''
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    numlock_by_default = true
    follow_mouse = 1
    mouse_refocus=false
    touchpad {
        natural_scroll = true 
        scroll_factor = 1.0  # Touchpad scroll factor
    }
    sensitivity = 0 # Pointer speed: -1.0 - 1.0, 0 means no modification.
}
gestures {
    workspace_swipe = true
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
  '';


}

