

{ config, pkgs, ... }:
{
  imports = [
    ./lua/plugins
    ./lua/vim-options.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
    gh
    fd
    wget
    nodejs
    ripgrep # Thêm rigrep
    gcc
    python312
    #LSP
    clang-tools
    lua-language-server
   stylua
    nil
    pyright
    typescript-language-server
    #formater
    prettierd
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      render-markdown-nvim
      nvim-treesitter # treesitter
      nvim-autopairs # autoclose tag
      nvim-ts-autotag
      smear-cursor-nvim
      comment-nvim
    ];

  };

  home.file.".config/nvim/init.lua".text = ''
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- local performance = { reset_packpath = false, rtp = { reset = false } }
-- require("lazy").setup(plugins, opts, performance)
require("vim-options")
require("lazy").setup("plugins")

  '';

}
