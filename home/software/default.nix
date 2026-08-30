{pkgs, ...}: {
  imports = [
    ./rofi
    # ./browsers/chromium.nix
    # ./browsers/edge.nix
    ./browsers/firefox.nix
    ./browsers/chrome.nix
    ./gtk.nix
    ./media
    ./anydesk.nix
  ];

  home.packages = with pkgs; [
    # messaging
    vesktop
    tor-browser
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
    tailscale
    sshfs
    slack

    wpsoffice
    spotify
    mysql-workbench
    dbeaver-bin
    # edit image
    mars-mips
    bc
    gimp

    ## CLI testing
    cron
  ];
}
