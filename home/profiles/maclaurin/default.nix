{
  imports = [
    # editors
    ../../editors/nvim

    # ../../editors/zed

    # media services
    ../../services/media/playerctl.nix

    # system services
    ../../services/system/gpg-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/obsidian-sync.nix
    # ../../services/system/syncthing.nix

    # software
    ../../software

    # terminal emulators
    ../../terminal/emulators/wezterm.nix
  ];
}
