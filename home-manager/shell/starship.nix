
{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = ''

  [](blue)$os[](bg:blue fg:blue)$username[](bg:blue fg:blue)$directory[ ](fg:blue) $git_branch $git_status $all $character
      '';

      username = {
        show_always = true;
        format = "[$user ](bg:blue fg:black)";
        disabled = false;
      };

      os = {
        disabled = false;
        style = "bg:blue fg:black";
        symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CachyOS = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          Nobara = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };
      };

      cmd_duration.format = "[$duration](fg:red)";

      directory = {
        format = "[$path](bg:blue fg:black)";
        truncation_length = 2;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = "󰝚 ";
          "Pictures" = " ";
          "Scripts" = "󰲋 ";
        };
      };

      character = {
        success_symbol = "[](bold blue)";
        error_symbol = "[✗](bold red)";
        disabled = false;
      };

      git_branch = {
        symbol = "  ";
        format = "[$symbol($branch) ($version)]($style)";
      };

      git_commit = {
        tag_symbol = "  ";
        format = "[$symbol($version)]($style)";
      };

      git_status = {}; # giữ mặc định hoặc thêm nếu cần

      fossil_branch = {
        symbol = "  ";
        format = "[$symbol($version)]($style)";
      };

      aws.symbol = "   ";
      buf.symbol = "  ";
      c.symbol = "  ";
      cmake.symbol = "  ";
      conda.symbol = "  ";
      crystal.symbol = "  ";
      dart.symbol = "  ";
      docker_context.symbol = "  ";
      elixir.symbol = "  ";
      elm.symbol = "  ";
      fennel.symbol = "  ";
      golang.symbol = "  ";
      guix_shell.symbol = "   ";
      haskell.symbol = "  ";
      haxe.symbol = "  ";
      hg_branch.symbol = "  ";
      hostname = {
        ssh_symbol = "  ";
        format = "[$symbol($version)]($style)";
      };
      java.symbol = "  ";
      julia.symbol = "  ";
      kotlin.symbol = "  ";
      lua.symbol = "  ";
      memory_usage.symbol = " 󰍛 ";
      meson.symbol = " 󰔷 ";
      nim.symbol = " 󰆥 ";
      nix_shell.symbol = "  ";
      nodejs.symbol = "  ";
      ocaml.symbol = "  ";
      package.symbol = " 󰏗 ";
      perl.symbol = "  ";
      php.symbol = "  ";
      pijul_channel.symbol = "  ";
      python.symbol = "  ";
      rlang.symbol = " 󰟔 ";
      ruby.symbol = "  ";
      rust.symbol = " 󱘗 ";
      scala.symbol = "  ";
      swift.symbol = "  ";
      zig.symbol = "  ";
      gradle.symbol = "  ";
    };
  };
}
