{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    hyprshot
  ];
}
