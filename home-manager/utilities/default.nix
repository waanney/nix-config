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
      lsof
      docker-compose
      xvfb-run
      wpsoffice
      gdb
      haruna #video player
      nautilus
      openvpn
      libinput
      discord-ptb    
    ];
   programs.yazi = {
     enable = true;
     settings = {
        manager = {
          ratio = [
            1
            4
            3
          ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
      };

      preview = {
        image_filter = "lanczos3";
        image_quality = 90;
        tab_size = 1;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };
  };

  };
  }
