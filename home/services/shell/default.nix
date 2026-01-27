{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  quickshell = inputs.quickshell.packages.${system}.default;
  
  # Path to shell QML files
  shellPath = ./.;
in {
  home.packages = [
    quickshell
    pkgs.matugen
    pkgs.kdePackages.qt5compat
    pkgs.kdePackages.qtbase
    pkgs.kdePackages.qtdeclarative
    pkgs.fish
    pkgs.brightnessctl
    pkgs.networkmanager
    pkgs.wl-clipboard
    pkgs.libqalculate
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

  # Copy shell configuration to ~/.config/quickshell
  xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  xdg.configFile."quickshell/modules".source = ./modules;
  xdg.configFile."quickshell/components".source = ./components;
  xdg.configFile."quickshell/config".source = ./config;
  xdg.configFile."quickshell/assets".source = ./assets;
  xdg.configFile."quickshell/utils".source = ./utils;
  xdg.configFile."quickshell/services".source = ./services;
}
