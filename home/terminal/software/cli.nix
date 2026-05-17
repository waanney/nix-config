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
      (pkgs.writeShellScriptBin "tm-ai" ''
        PN="$1"
        CWD="$2"
        AGENT="''${3:-claude}"
        SESSION="ai_$AGENT"

        # Đảm bảo session tồn tại
        tmux has-session -t "$SESSION" 2>/dev/null || \
          tmux new-session -d -s "$SESSION" -c "$CWD" -n "$PN" "$AGENT"

        # Tìm hoặc tạo window cho project
        tmux select-window -t "$SESSION":"$PN" 2>/dev/null || \
          (tmux new-window -t "$SESSION" -c "$CWD" -n "$PN" "$AGENT" && \
           tmux set-window-option -t "$SESSION":"$PN" allow-rename off)

        # Quan trọng: Unset TMUX để cho phép lồng session trong popup
        unset TMUX
        tmux attach-session -t "$SESSION":"$PN"
      '')
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

    "server-vps-255" = {
      host = "vps255";
      hostname = "103.73.232.255";
      user = "root";
      port = 15894;
      identityFile = "~/.ssh/id_rsa";
    };

    "schoolux-read" = {
      host = "schooluxR";
      hostname = "157.230.247.139";
      user = "team2reader";
    };

    "schoolux-write" = {
      host = "schooluxW";
      hostname = "178.128.20.226";
      user = "root";
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
