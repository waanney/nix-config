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
--lsp-config
keymap.set("n", "K", vim.lsp.buf.hover, {})
keymap.set("n", "gd", vim.lsp.buf.definition, {})
keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
keymap.set("n", "gr", vim.lsp.buf.references, {})

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")



vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader =" "
vim.opt.fillchars = { eob = " " }
vim.opt.relativenumber = true
vim.cmd("set clipboard=unnamedplus")
