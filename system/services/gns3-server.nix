{
  lib,
  pkgs,
  ...
}: {
  # Shared GNS3 server: clients use "Run appliances on a remote server" and
  # point at this host's Tailscale name on port 3080.  Projects and images
  # live in /var/lib/gns3, so everyone edits the same topologies.
  services.gns3-server = {
    enable = true;
    ubridge.enable = true;
    dynamips.enable = true;
    vpcs.enable = true;

    # Create on the host, outside the Nix store:
    #   sudo install -Dm600 /dev/stdin /var/lib/gns3-auth/password
    auth = {
      enable = true;
      user = "gns3";
      passwordFile = "/var/lib/gns3-auth/password";
    };

    settings.Server = {
      host = "0.0.0.0";
      port = 3080;
    };
  };

  # The upstream module only adds QEMU and /dev/kvm when libvirtd is enabled.
  systemd.services.gns3-server = {
    path = [pkgs.qemu_kvm];
    serviceConfig = {
      DeviceAllow = ["/dev/kvm"];
      SupplementaryGroups = ["kvm"];
      # Dynamips and QEMU generate code at runtime.
      MemoryDenyWriteExecute = lib.mkForce false;
    };
  };

  # Reachable only from the tailnet, never from LAN or the internet.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [3080];
}
