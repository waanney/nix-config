{
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  quickshell = inputs.quickshell.packages.${system}.default;
in {
  home.packages = [
    quickshell
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
  ];

  xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  xdg.configFile."quickshell/components".source = ./components;
  xdg.configFile."quickshell/sysinfo.sh" = {
    source = ./sysinfo.sh;
    executable = true;
  };
}
