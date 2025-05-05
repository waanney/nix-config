{pkgs, inputs, system, ...}: {
  imports = [
    ./hyprland
  ];


  home.packages = with pkgs; [
    hyprshot
    inputs.zen-browser.packages."${system}".twilight-official
    obs-studio
  ];
}
