{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

    # Bỏ qua Wayland native và ép dùng XWayland + tắt scale tự động để fix lỗi màn hình đen
    package = pkgs.steam.override {
      extraProfile = ''
        unset NIXOS_OZONE_WL
        unset SDL_VIDEODRIVER
        export STEAM_FORCE_DESKTOPUI_SCALING=1
      '';
    };
  };
}
