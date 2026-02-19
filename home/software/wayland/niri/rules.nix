{...}: let
  windowRules = [
 
    {
      geometry-corner-radius = let
        radius = 0.0;
      in {
        bottom-left = radius;
        bottom-right = radius;
        top-left = radius;
        top-right = radius;
      };
      clip-to-geometry = true;
      draw-border-with-background = false;
    }

    # Workspace 1: Giao tiếp & Admin (Communication)
    {
      matches = [
        {app-id = "slack";}
        {app-id = "com.slack.Slack";}
        {app-id = "org.telegram.desktop";}
        {app-id = "app.drey.PaperPlane";}
        {app-id = "com.github.zalopay.zalo";}
        {app-id = "thunderbird";}
        {app-id = "org.mozilla.Thunderbird";}
        {app-id = "evolution";}
        {app-id = "org.gnome.Evolution";}
        {app-id = "gnome-calendar";}
        {app-id = "org.gnome.Calendar";}
        {app-id = "discord";}
        {app-id = "com.discordapp.Discord";}
      ];
      open-on-workspace = "1-communication";
    }
    # Workspace 2: Làm việc chính (Deep Work / Dev)
    {
      matches = [
        {app-id = "code";}
        {app-id = "com.visualstudio.code";}
        {app-id = "code-oss";}
        {app-id = "jetbrains-idea";}
        {app-id = "jetbrains-pycharm";}
        {app-id = "jetbrains-clion";}
        {app-id = "jetbrains-rubymine";}
        {app-id = "jetbrains-webstorm";}
        {app-id = "com.jetbrains.IntelliJ-IDEA-Community";}
        {app-id = "com.jetbrains.PyCharm-Community";}
        {app-id = "wezterm";}
        {app-id = "org.wezfurlong.wezterm";}
        {app-id = "foot";}
        {app-id = "alacritty";}
        {app-id = "kitty";}
        {app-id = "obsidian";}
        {app-id = "md.obsidian.Obsidian";}
        {app-id = "notion-app";}
        {app-id = "notion";}
      ];
      open-on-workspace = "2-development";
    }
    # Workspace 3: Tra cứu & Tham khảo (Research / Browser)
    {
      matches = [
        {app-id = "firefox";}
        {app-id = "zen";}
        {app-id = "chromium-browser";}
        {app-id = "chromium";}
        {app-id = "google-chrome";}
        {app-id = "com.google.Chrome";}
        {app-id = "edge";}
        {app-id = "microsoft-edge";}
        {app-id = "brave-browser";}
        {app-id = "com.brave.Browser";}
      ];
      open-on-workspace = "3-browsing";
    }
    # Workspace 4: Giải trí & Tiện ích (Media / Background)
    {
      matches = [
        {app-id = "spotify";}
        {app-id = "com.spotify.Client";}
        {app-id = "ncspot";}
        {app-id = "mpv";}
        {app-id = "vlc";}
        {app-id = "org.videolan.VLC";}
        {app-id = "btop";}
        {app-id = "htop";}
        {app-id = "yazi";}
        {app-id = "thunar";}
        {app-id = "org.xfce.thunar";}
        {app-id = "nautilus";}
        {app-id = "org.gnome.Nautilus";}
        {app-id = "dolphin";}
        {app-id = "org.kde.dolphin";}
        {app-id = "pcmanfm";}
      ];
      open-on-workspace = "4-media";
    }
    {
      matches = [
        {is-floating = true;}
      ];
      shadow.enable = true;
    }
    {
      matches = [
        {
          is-window-cast-target = true;
        }
      ];
      focus-ring = {
        active.color = "#f38ba8";
        inactive.color = "#7d0d2d";
      };
      border = {
        inactive.color = "#7d0d2d";
      };
      shadow = {
        color = "#7d0d2d70";
      };
      tab-indicator = {
        active.color = "#f38ba8";
        inactive.color = "#7d0d2d";
      };
    }
    {
      matches = [{app-id = "org.telegram.desktop";}];
      block-out-from = "screencast";
    }
    {
      matches = [{app-id = "app.drey.PaperPlane";}];
      block-out-from = "screencast";
    }
    {
      matches = [
        {app-id = "zen";}
        {app-id = "firefox";}
        {app-id = "chromium-browser";}
        {app-id = "xdg-desktop-portal-wlr";}
      ];
      scroll-factor = 0.5;
    }
    {
      matches = [
        {app-id = "zen";}
        {app-id = "firefox";}
        {app-id = "chromium-browser";}
        {app-id = "edge";}
      ];
      open-maximized = true;
    }
    {
      matches = [
        {
          app-id = "firefox";
          title = "Picture-in-Picture";
        }
      ];
      open-floating = true;
      default-floating-position = {
        x = 32;
        y = 32;
        relative-to = "bottom-right";
      };
      default-column-width = {fixed = 480;};
      default-window-height = {fixed = 270;};
    }
    {
      matches = [
        {
          app-id = "zen";
          title = "Picture-in-Picture";
        }
      ];
      open-floating = true;
      default-floating-position = {
        x = 32;
        y = 32;
        relative-to = "bottom-right";
      };
      default-column-width = {fixed = 480;};
      default-window-height = {fixed = 270;};
    }
    {
      matches = [{title = "Picture in picture";}];
      open-floating = true;
      default-floating-position = {
        x = 32;
        y = 32;
        relative-to = "bottom-right";
      };
    }
    {
      matches = [{title = "Discord Popout";}];
      open-floating = true;
      default-floating-position = {
        x = 32;
        y = 32;
        relative-to = "bottom-right";
      };
    }
    {
      matches = [{app-id = "pavucontrol";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "pavucontrol-qt";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "com.saivert.pwvucontrol";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "io.github.fsobolev.Cavalier";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "dialog";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "popup";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "task_dialog";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "gcr-prompter";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "file-roller";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "org.gnome.FileRoller";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "nm-connection-editor";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "blueman-manager";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "xdg-desktop-portal-wlr";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "org.kde.polkit-kde-authentication-agent-1";}];
      open-floating = true;
    }
    {
      matches = [{app-id = "pinentry";}];
      open-floating = true;
    }
    {
      matches = [{title = "Progress";}];
      open-floating = true;
    }
    {
      matches = [{title = "File Operations";}];
      open-floating = true;
    }
    {
      matches = [{title = "Copying";}];
      open-floating = true;
    }
    {
      matches = [{title = "Moving";}];
      open-floating = true;
    }
    {
      matches = [{title = "Properties";}];
      open-floating = true;
    }
    {
      matches = [{title = "Downloads";}];
      open-floating = true;
    }
    {
      matches = [{title = "file progress";}];
      open-floating = true;
    }
    {
      matches = [{title = "Confirm";}];
      open-floating = true;
    }
    {
      matches = [{title = "Authentication Required";}];
      open-floating = true;
    }
    {
      matches = [{title = "Notice";}];
      open-floating = true;
    }
    {
      matches = [{title = "Warning";}];
      open-floating = true;
    }
    {
      matches = [{title = "Error";}];
      open-floating = true;
    }
  ];
in {
  programs.niri.settings = {
    window-rules = windowRules;
    layer-rules = [
      {
        matches = [{namespace = "^swww$";}];
        place-within-backdrop = true;
      }
    ];
  };
}
