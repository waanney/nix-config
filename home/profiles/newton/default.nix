{
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
}
