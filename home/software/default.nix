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
    (texlive.combine {inherit (texlive) scheme-full;})
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
    tailscale
    sshfs
    slack

    code-cursor
    cursor-cli
    wpsoffice
    spotify
    mysql84
    mysql-workbench
    postgresql
    dbeaver-bin
    # edit image
    mars-mips
    bc
    krita
    gimp

    ## CLI testing
    cron

    # Virtualization
    virt-manager
    quickemu
    quickgui
  ];
}
