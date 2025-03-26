{pkgs, inputs, system, ...}: {
  home.packages = with pkgs; [
    hyprshot
    inputs.zen-browser.packages."${system}".twilight-official
  ];
}
