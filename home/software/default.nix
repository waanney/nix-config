{
  pkgs,
  ...
}: {
  imports = [
    ./rofi
    # ./browsers/chromium.nix
    # ./browsers/edge.nix
    ./browsers/firefox.nix
    ./gtk.nix
    ./media
  ];

  home.packages = with pkgs; [
    # messaging
    vesktop
    (texlive.combine { inherit (texlive) scheme-full; })
    # misc
    ps_mem
    pciutils
    nixos-icons
    colord
    cliphist
    ffmpegthumbnailer
    imagemagick
    bun

    fastfetch

    libreoffice
    amberol
    cavalier
    (celluloid.override {youtubeSupport = true;})
    dconf-editor
    eyedropper
    gnome-control-center
    gnome-text-editor
    loupe
    nautilus
    (papers.override {supportNautilus = true;})
    pwvucontrol
    resources

    obsidian
    mods
    tailscale
    sshfs
    slack

    code-cursor
    cursor-cli
  ];
}
