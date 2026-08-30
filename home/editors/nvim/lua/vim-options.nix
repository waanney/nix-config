{
  config,
  pkgs,
  ...
}: {
  home.file.".config/nvim/lua/vim-options.lua".text = ''
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    -- Leader key (Phải đặt ở đầu để các keymap bên dưới nhận đúng phím Space)
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

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
    -- Floating Terminal Helper (tự động dùng popup trong Neovim khi không chạy trong Tmux)
    local function open_floating_terminal(cmd, title)
      local width = math.floor(vim.o.columns * 0.85)
      local height = math.floor(vim.o.lines * 0.85)
      local col = math.floor((vim.o.columns - width) / 2)
      local row = math.floor((vim.o.lines - height) / 2)

      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = " " .. (title or "Terminal") .. " ",
        title_pos = "center",
      })

      vim.fn.termopen(cmd, {
        on_exit = function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end,
      })
      vim.cmd("startinsert")
    end

    -- AI & Git Popups
    keymap.set("n", "<leader>ai", function()
      local path = vim.fn.expand("%:p")
      if path == "" then path = vim.fn.getcwd() end
      local project_root = vim.fs.root(path, { ".git", "flake.nix", "package.json" }) or vim.fs.dirname(path)

      local agents = { "agy", "claude", "pi-coding-agent", "codex", "opencode" }
      vim.ui.select(agents, { prompt = "Select AI Agent:" }, function(choice)
        if not choice then return end

        if vim.env.TMUX and vim.env.TMUX ~= "" then
          local cmd = string.format("tmux display-popup -E -w 85\\%% -h 85\\%% 'tm-ai \"%s\" \"%s\"'", project_root, choice)
          vim.cmd("!" .. cmd)
        else
          open_floating_terminal(choice, "AI Agent: " .. choice)
        end
      end)
    end, { desc = "AI Coding Agent Popup" })

    -- Lazygit popup (hỗ trợ cả trong lẫn ngoài tmux)
    keymap.set("n", "<leader>gg", function()
      if vim.env.TMUX and vim.env.TMUX ~= "" then
        vim.cmd("silent !tmux display-popup -E -w 85\\% -h 85\\% 'lazygit'")
      else
        open_floating_terminal("lazygit", "Lazygit")
      end
    end, { desc = "Lazygit Popup" })

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
