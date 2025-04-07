{ config, pkgs, ... }:
{
  # Packages for LSP, linter - Neovim
  home.packages = with pkgs; [
    wl-clipboard
    gh
    fd
    wget
    nodejs
    ripgrep # Thêm rigrep
    gcc
    #LSP
    clang-tools
    lua-language-server
    stylua
    nil
    pyright
    typescript-language-server
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter # treesitter
      pkgs.vimPlugins.nvim-autopairs # autoclose tag
      pkgs.vimPlugins.nvim-ts-autotag
      ] ;

  };

  home.file = {
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
  };
}
