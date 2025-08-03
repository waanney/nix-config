{pkgs, inputs, system, ...}: {
  imports = [
    ./hyprland
  ];


  home.packages = with pkgs; [
    hyprshot
    obs-studio
    firefox
    inputs.zen-browser.packages."${system}".default
  ];
}
