{ pkgs, ... }: # Ensure pkgs is available in your arguments

{
  virtualisation.docker.enable = true;

  # programs.adb.enable = true; # REMOVE OR DELETE THIS LINE

  # To keep using the 'adb' command, add the tools package here:
  # environment.systemPackages = [
  #   pkgs.android-tools
  # ];
}
