{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols

      # normal fonts
      noto-fonts
      noto-fonts-color-emoji
      adwaita-fonts
      inter

      # nerdfonts
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono

      # microsoft font compatibility
      corefonts
    ];

    # causes more issues than it solves
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = false;
        style = "full";
      };
      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
      defaultFonts = let
        addAll = builtins.mapAttrs (_: v: ["Symbols Nerd Font"] ++ v ++ ["Noto Color Emoji"]);
      in
        addAll {
          serif = ["Noto Serif" "Noto Sans Serif"];
          sansSerif = ["Inter" "Adwaita Sans"];
          monospace = ["JetBrainsMono Nerd Font" "Adwaita Mono"];
          emoji = ["Noto Color Emoji"];
        };
    };
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
  };
}
