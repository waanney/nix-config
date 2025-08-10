{
  pkgs,
  ...
}: {
  imports = [
    ./anyrun
    # ./browsers/chromium.nix
    # ./browsers/edge.nix
    ./browsers/firefox.nix
    ./gtk.nix
    ./media
  ];

  home.packages = with pkgs; [
    # messaging
    vesktop

    # misc
    ps_mem
    pciutils
    nixos-icons
    colord
    cliphist
    ffmpegthumbnailer
    imagemagick
    nodejs
    nodePackages.pnpm
    bun

    fastfetch

    libreoffice
    amberol
    cavalier
    (celluloid.override {youtubeSupport = true;})
    dconf-editor
    eyedropper
    file-roller
    gnome-control-center
    gnome-text-editor
    loupe
    nautilus
    (papers.override {supportNautilus = true;})
    pwvucontrol
    resources

    inkscape
    gimp
    # krita
    scrcpy
    multiviewer-for-f1

    mods
  ];
}
