{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # archives
      zip
      unzip
      unrar

      # misc
      libnotify
      fontconfig

      # utils
      dust
      duf
      fd
      file
      jaq
      ripgrep
      killall
      jq
      
      # SSH/remote
      mosh

      discordo
      fum
      glow
      gtt
      meteor-git
      reddit-tui
      scope-tui
      tuicam
      wiremix
      zfxtop
      nix-search-tv
      television

      gdb
    ]
    ++ (with inputs.mynixpkgs.packages.${pkgs.stdenv.hostPlatform.system}; [
      opencode
      toney
      bmm
      omm
      prs
      dfft
      crush
    ]);

  programs = {
    eza.enable = true;
ssh = {
  enable = true;
  enableDefaultConfig = false;

  matchBlocks = {
    # Block 1: Cấu hình chung cho mọi host
    "general" = {
      host = "*";
      forwardAgent = false;
      compression = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/master-%r@%h:%p";
      controlPersist = "10m";
    };

    # Block 2: Cấu hình riêng cho server của bạn
    "my-server" = {
      host = "100.104.251.17";
      hostname = "100.104.251.17";
      user = "ngphuoc";
    };
  };
};
    dircolors = {
      enable = true;
      # enableNushellIntegration = true;
    };
    autojump = {
      enable = true;
      # enableNushellIntegration = true;
    };
  };
}
