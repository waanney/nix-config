{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-symbols

      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
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
          serif = ["Noto Serif" "Noto Serif CJK JP" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK KR"];
          sansSerif = ["Inter" "Adwaita Sans" "Noto Sans" "Noto Sans CJK JP" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK KR"];
          monospace = ["JetBrainsMono Nerd Font" "Adwaita Mono" "Noto Sans Mono CJK JP" "Noto Sans Mono CJK SC" "Noto Sans Mono CJK TC" "Noto Sans Mono CJK KR"];
          emoji = ["Noto Color Emoji"];
        };
    };
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
  };
}
