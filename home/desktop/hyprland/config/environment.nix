

{ config, pkgs, ... }:
{

  home.file.".config/hypr/config/environment.conf".text =''
#############################
### ENVIRONMENT VARIABLES ###
#############################


env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24

  '';


}

