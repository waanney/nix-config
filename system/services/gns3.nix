{
  lib,
  pkgs,
  ...
}: {
  # GNS3 GUI starts its own local server as the logged-in user, so images and
  # projects stay in ~/GNS3.  The server finds ubridge through PATH, where
  # /run/wrappers/bin comes first and carries the needed capabilities.
  users.groups.ubridge = {};

  # mkDefault: the gns3-server module defines the same wrapper on newton.
  security.wrappers.ubridge = lib.mapAttrs (_: lib.mkDefault) {
    source = "${pkgs.ubridge}/bin/ubridge";
    capabilities = "cap_net_raw,cap_net_admin=eip";
    owner = "root";
    group = "ubridge";
    permissions = "u=rx,g=rx,o=";
  };

  environment.systemPackages = with pkgs; [
    gns3-gui
    gns3-server
    dynamips
    vpcs
    qemu_kvm
    inetutils # telnet for node consoles
  ];
}
