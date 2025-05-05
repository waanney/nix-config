{ config, pkgs, ... }:
{
  #packages for lsp, linter - nvim
  home.packages = with pkgs; [
  ];

  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode";
      size = 12.0;
    };

    settings = {
      confirm_os_window_close = "0";

      cursor_shape = "block";
      cursor_blink_interval = "1.0";  # cursor_blinking = true

      scrollback_lines = "10000";
      paste_actions = "quote-urls-at-prompt,confirm,confirm-if-large";

      cursor_foreground = "#c5c6c2";
      cursor_background = "#191c0e";

      background_opacity = "0.8";
      background_blur = "1";

      shell_prompt = "fg:blue";
      shell_prompt_git = "fg:green";
      shell_prompt_python = "fg:yellow";

      active_tab_background = "#c5c6c2";
      inactive_tab_background = "#191c0e";
      active_tab_foreground = "#191c0e";
      inactive_tab_foreground = "#c5c6c2";

      window_border_width = "2";
      window_border_color = "#c5c6c2";
    };

  };
}


