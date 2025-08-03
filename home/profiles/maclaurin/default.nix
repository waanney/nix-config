{
  imports = [
    # editors
    ../../editors/nvim
    ../../editors/zed

    # services
    ../../services/wayland/hypridle.nix

    # media services
    ../../services/media/playerctl.nix

    # system services
    ../../services/system/gpg-agent.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/syncthing.nix

    # software
    ../../software
    ../../software/wayland



    # terminal emulators
    # ../../terminal/emulators/foot.nix
  ];
}
