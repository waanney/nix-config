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

    # Block 2: Cấu hình riêng cho server hiện tại
    "my-server" = {
      host = "100.104.251.17";
      hostname = "100.104.251.17";
      user = "ngphuoc";
    };

    # Block 3: Cấu hình cũ (giữ lại nếu bạn vẫn dùng)
    "server-root-103-old" = {
      host = "server-old";
      hostname = "103.73.232.250";
      user = "root";
      port = 17022;
      identityFile = "~/.ssh/id_rsa";
    };

    # Block 4: Cấu hình MỚI từ hình ảnh bạn gửi
    "server-vps-247" = {
      host = "vps247";              # Tên gợi nhớ để gõ lệnh nhanh
      hostname = "103.73.232.247";  # IP từ ảnh
      user = "root";                # User từ ảnh
      port = 56107;                 # Port từ ảnh
      identityFile = "~/.ssh/id_rsa_tho";
    };

    "server-vps-241" = {
      host = "vps241";
      hostname = "156.67.214.241";
      user = "root";
      identityFile = "~/.ssh/id_rsa";
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
