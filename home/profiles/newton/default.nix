{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Editors
    ../../editors/nvim

    # Services cơ bản
    ../../services/media/playerctl.nix
    ../../services/system/gpg-agent.nix

    # Bỏ: power-monitor (không cần theo dõi pin trên desktop)
    # Bỏ: hypridle (GNOME có idle/lock manager riêng)
    # Bỏ: obsidian-sync (tùy chọn — thêm sau nếu cần)
    # Bỏ: polkit-agent (GNOME Shell đã cung cấp authentication agent)
    # Bỏ: services/shell (quickshell / Caelestia — không dùng trên GNOME)
    # Bỏ: software/wayland (niri, hyprlock — không dùng trên GNOME)

    # Software chung (Firefox, v.v.)
    ../../software

    # Terminal emulator
    ../../terminal/emulators/wezterm.nix
  ];

  home.file."Pictures/Wallpapers/woods.png".source =
    ../../../assets/wallpapers + "/Wallpaper_woods_upscayl_4x_RealESRGAN_General_x4_v3(1).png";

  dconf.settings."org/gnome/desktop/background" = {
    picture-uri = "file://${config.home.homeDirectory}/Pictures/Wallpapers/woods.png";
    picture-uri-dark = "file://${config.home.homeDirectory}/Pictures/Wallpapers/woods.png";
    picture-options = "zoom";
  };

  # Desktop: allow screen blanking/locking, but don't suspend unattended builds
  # or simulations. Manual suspend is still available from the system menu.
  dconf.settings."org/gnome/settings-daemon/plugins/power" = {
    sleep-inactive-ac-type = "nothing";
    sleep-inactive-ac-timeout = 0;
  };

  # Gazebo's saved GUI theme takes precedence over Qt environment variables.
  # Quick Start uses white surfaces, so use matching light controls. Preserve
  # plugins and layout, but close the simulation rather than leaving its server
  # running where it can hijack the next quick-start world selection.
  home.activation.gazeboDarkTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
        guiConfig="${config.home.homeDirectory}/.gz/sim/8/gui.config"
        if [ -f "$guiConfig" ] && [ ! -L "$guiConfig" ]; then
          # Gazebo initially copies this file from the read-only Nix store.
          # It must remain writable for saving layout and quick-start preferences.
          run ${pkgs.coreutils}/bin/chmod u+w "$guiConfig"
          run ${pkgs.gnused}/bin/sed -i \
            's/material_theme="[^"]*"/material_theme="Light"/g' "$guiConfig"
          run ${pkgs.perl}/bin/perl -0pi -e '
            s{<dialog_on_exit>.*?</dialog_on_exit>}{<dialog_on_exit>true</dialog_on_exit>}sg;
            s{\s*<default_exit_action>.*?</default_exit_action>}{}sg;
            s{\s*<dialog_on_exit_options>.*?</dialog_on_exit_options>}{}sg;
            s{</window>}{    <default_exit_action>SHUTDOWN_SERVER</default_exit_action>
        <dialog_on_exit_options>
            <show_shutdown_button>true</show_shutdown_button>
            <shutdown_button_text>Shutdown simulation</shutdown_button_text>
            <show_close_gui_button>false</show_close_gui_button>
        </dialog_on_exit_options>
    </window>}g;
          ' "$guiConfig"
        fi
  '';
}
