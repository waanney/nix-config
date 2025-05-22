 { config, pkgs, ... }:

  {
    home.packages = with pkgs; [
      lshw # get video card bus
      yt-dlp # youtube downloader
      exfat
      zip
      unzip
      logisim-evolution
      postman
      redis
      google-chrome
      lsof
      deno
      firefox
      docker-compose
      xvfb-run
      discord
      libreoffice
      gdb
      nodePackages.localtunnel
      haruna
    ];
  }
