
{ config, pkgs, ... }:
{

  home.file.".config/nvim/lua/vim-options.lua".text =''
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--Delete a word backwards
keymap.set("n", "dw", "vb_d")
--Select all
keymap.set("n", "<C-a>", "gg<S-v>G")
--Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")


-- Tab settings
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Display settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.fillchars = { eob = " " }
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Performance settings
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- File settings
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- Clipboard
vim.cmd("set clipboard=unnamedplus")

-- Mouse support
vim.opt.mouse = "a"

  '';


}

