 { config, pkgs, ... }:

  {
    home.packages = with pkgs; [
      fastfetch # get system information on terminal
      lshw # get video card bus
      yt-dlp # youtube downloader
      exfat
      zip
      unzip
      logisim-evolution
    ];
  }
