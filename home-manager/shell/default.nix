{ config, pkgs, ... }:
{
  #packages for lsp, linter - nvim
  home.packages = with pkgs; [
    wl-clipboard
    xclip
    gh
  ];

  programs.git = {
    enable = true;
    userName = "waanney";
    userEmail = "work.buiminhquan@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias =  true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [ pkgs.vimPlugins.nvim-treesitter ];
  };

  programs.kitty ={
    enable = true;
  };

  programs.starship = {
    enable = true;
  };
  home.file = {
    ".config/kitty" = {
      source = ./.kitty;
      recursive = true;
    };
    ".config/nvim" = {
      source = ./.nvim;
      recursive = true;
    };
    ".zshrc" = {
      source = ./.zshrc;
    };
  };
}
