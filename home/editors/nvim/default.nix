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
    tree-sitter  # For treesitter CLI
    lua51Packages.jsregexp  # For LuaSnip transformations
    python311Packages.latexcodec  # For render-markdown latex support
    #LSP
    clang-tools
    lua-language-server
    stylua
    nil
    pyright
    typescript-language-server
    tailwindcss-language-server
    jdt-language-server  # Java
    rust-analyzer  # Rust
    texlab
    neovim-remote  # For inverse search (Ctrl+Click in PDF → jump to Neovim)
    #formater
    prettierd
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

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

require("vim-options")
require("lazy").setup("plugins", {
  -- Disable luarocks on NixOS (Nix manages dependencies)
  rocks = {
    enabled = false,
  },
  performance = {
    reset_packpath = false,  -- Don't reset packpath
    rtp = {
      reset = false,  -- Don't reset runtimepath
    },
  },
})

  '';

}
