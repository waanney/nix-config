{pkgs, ...}: {
  environment.shells = with pkgs; [nushell];
  environment.systemPackages = with pkgs; [carapace inshellisense];
}
