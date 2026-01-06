{pkgs, ...}: let
  domainname-wrapper = pkgs.writeShellScriptBin "domainname" ''
    hostname -d 2>/dev/null || hostname -f 2>/dev/null | cut -d. -f2- || echo ""
  '';
in {
  systemd.services.anydesk = {
    description = "AnyDesk Remote Desktop";
    wantedBy = ["multi-user.target"];
    path = with pkgs; [
      iproute2
      util-linux
      hostname
      inetutils
      coreutils
      bash
      domainname-wrapper
    ];
    serviceConfig = {
      Type = "simple";  # Change to simple instead of forking
      ExecStart = "${pkgs.anydesk}/bin/anydesk --service";
      Restart = "on-failure";
      TimeoutStartSec = 30;
      # Don't restart immediately if it fails
      RestartSec = 5;
    };
  };
}
