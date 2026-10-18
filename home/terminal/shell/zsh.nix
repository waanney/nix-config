{
  pkgs,
  config,
  ...
}: {
  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    shellAliases = {
      cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
      listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
      nixremove = "nix-store --gc";
      bloat = "nix path-info -Sh /run/current-system";
      c = "clear";
      q = "exit";
      cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
      trimall = "sudo fstrim -va";
      temp = "cd /tmp/";
      zed = "zeditor";
      koji = "meteor";
      gitui = "lazygit";

      test-build = "sudo nixos-rebuild test --flake .#aesthetic";
      switch-build = "sudo nixos-rebuild switch --flake .#aesthetic";

      # git
      g = "git";
      add = "git add .";
      commit = "git commit";
      push = "git push";
      pull = "git pull";
      diff = "git diff --staged";
      gcld = "git clone --depth 1";
      gco = "git checkout";
      gitgrep = "git ls-files | rg";

      cat = "bat --number --color=always --paging=never --tabs=2 --wrap=never";
      grep = "rg";
      l = "eza -lF --time-style=long-iso --icons";
      ll = "eza -h --git --icons --color=auto --group-directories-first -s extension";
      tree = "eza --tree --icons";

      # systemctl
      us = "systemctl --user";
      rs = "sudo systemctl";

      # virtualbox
      virtualbox = "QT_QPA_PLATFORM=xcb VirtualBox";
      VirtualBox = "QT_QPA_PLATFORM=xcb VirtualBox";
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };

    initContent = ''
      # Vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # Use fd to find directories and cd into them using sk
      fcd() {
        local dir=$(fd --type d | sk)
        if [[ -n "$dir" ]]; then
          cd "$dir"
        fi
      }

      # Yazi integration
      function fm() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      # Nix development templates helper
      dev() {
        if [ "$1" = "list" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
          echo "Available templates: web-dev, ai-dev, rust-dev, game-dev, latex-dev, java-dev, cybersecurity-dev"
          return 0
        fi
        local tmpl="''${1:-web-dev}"
        shift 2>/dev/null || true
        nix develop "dev#$tmpl" "$@"
      }

      devinit() {
        if [ "$1" = "list" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
          echo "Available templates: web-dev, ai-dev, rust-dev, game-dev, latex-dev, java-dev, cybersecurity-dev"
          return 0
        fi
        local tmpl="''${1:-web-dev}"
        echo "Initializing project from template: dev#$tmpl"
        nix flake init -t "dev#$tmpl"
      }
    '';
  };
}
