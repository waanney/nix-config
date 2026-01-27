{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages = [
    quickshell
    pkgs.matugen
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
    pkgs.gpu-screen-recorder
  ];

  home.sessionVariables = {
    QML2_IMPORT_PATH = lib.concatStringsSep ":" [
      (lib.makeSearchPath "lib/qt-6/qml" [
        quickshell
        pkgs.kdePackages.qtdeclarative
        pkgs.kdePackages.kirigami.unwrapped
        pkgs.kdePackages.qt5compat
      ])
    ];
  };

  # Quickshell desktop shell with panels
  xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  xdg.configFile."quickshell/panels/qmldir".source = ./panels/qmldir;
  xdg.configFile."quickshell/panels/leftbar.qml".source = ./panels/leftbar.qml;
  xdg.configFile."quickshell/panels/rightbar.qml".source = ./panels/rightbar.qml;
  xdg.configFile."quickshell/panels/topbar.qml".source = ./panels/topbar.qml;
  xdg.configFile."quickshell/panels/bottombar.qml".source = ./panels/bottombar.qml;
  xdg.configFile."quickshell/components".source = ./components;
}
