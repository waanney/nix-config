{
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    enable = false;
    package = pkgs.rofi;
    plugins = with pkgs; [];
    
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg-col = mkLiteral "#1e1e2e";
        bg-col-light = mkLiteral "#181825";
        border-col = mkLiteral "#89b4fa40";
        selected-col = mkLiteral "#313244";
        blue = mkLiteral "#8falseb4fa";
        fg-col = mkLiteral "#cdd6f4";
        fg-col2 = mkLiteral "#bac2de";
        grey = mkLiteral "#6c7086";
        width = mkLiteral "600";
        font = mkLiteral "\"SF Pro Display 14\"";
      };

      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      "window" = {
        height = mkLiteral "360px";
        width = mkLiteral "600px";
        border = mkLiteral "2px";
        border-color = mkLiteral "@border-col";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "24px";
        padding = mkLiteral "8px";
      };

      "mainbox" = {
        background-color = mkLiteral "@bg-col";
      };

      "inputbar" = {
        children = mkLiteral "[prompt,entry]";
        background-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "12px";
        margin = mkLiteral "8px";
      };

      "prompt" = {
        background-color = mkLiteral "@blue";
        padding = mkLiteral "8px 12px";
        text-color = mkLiteral "@bg-col";
        border-radius = mkLiteral "8px";
        margin = mkLiteral "0px 8px 0px 0px";
        font-weight = mkLiteral "bold";
      };

      "textbox-prompt-colon" = {
        expand = mkLiteral "false";
        str = mkLiteral "\"󱄅\"";
      };

      "entry" = {
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@fg-col";
        padding = mkLiteral "8px";
        border-radius = mkLiteral "8px";
      };

      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "4px 8px";
        margin = mkLiteral "4px 0px";
        columns = 1;
        lines = 8;
        background-color = mkLiteral "@bg-col";
      };

      "element" = {
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@fg-col";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "12px";
        margin = mkLiteral "2px";
      };

      "element-icon" = {
        size = mkLiteral "28px";
      };

      "element selected" = {
        background-color = mkLiteral "@selected-col";
        text-color = mkLiteral "@fg-col";
        border = mkLiteral "1px";
        border-color = mkLiteral "@blue";
      };

      "mode-switcher" = {
        spacing = 0;
      };

      "button" = {
        padding = mkLiteral "12px";
        background-color = mkLiteral "@bg-col-light";
        text-color = mkLiteral "@grey";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "@bg-col";
        text-color = mkLiteral "@blue";
      };

      "message" = {
        background-color = mkLiteral "@bg-col-light";
        margin = mkLiteral "8px";
        padding = mkLiteral "8px";
        border-radius = mkLiteral "8px";
      };

      "textbox" = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "8px";
        text-color = mkLiteral "@blue";
        background-color = mkLiteral "@bg-col-light";
      };
    };

    extraConfig = {
      modi = "drun,window,run,ssh,combi,keys,filebrowser,recursivebrowser";
      show-icons = true;
      terminal = "wezterm";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-window = "󰖲";
      display-run = "󰆍";
      display-ssh = "󰥔";
      display-drun = "󱄅";
      display-combi = "󰧨";
      display-keys = "󰌌";
      display-filebrowser = "󰉋";
      display-recursivebrowser = "󰝰";
      sidebar-mode = true;
      font = "SF Pro Display 14";
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
      case-sensitive = false;
      lines = 8;
      columns = 1;
      fixed-num-lines = false;
      fullscreen = false;
      padding = 8;
      horizontal = false;
      min-height = 0;
      combi-modi = "window,drun,run,ssh";
      matching-negate-char = "-";
    };
  };
}

