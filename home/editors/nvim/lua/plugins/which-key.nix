{
  home.file.".config/nvim/lua/plugins/which-key.lua".text =''
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "rounded",
        padding = { 2, 2, 2, 2 },
      },
    })

    -- Register key mappings with descriptions
    wk.add({
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>fg", desc = "Live Grep" },
      { "<leader>fb", desc = "Buffers" },
      { "<leader>fh", desc = "Help Tags" },
      { "<leader>fs", desc = "Grep String" },
      { "<leader>fo", desc = "Old Files" },
      
      { "<leader>h", group = "Git Hunks" },
      { "<leader>hs", desc = "Stage Hunk" },
      { "<leader>hr", desc = "Reset Hunk" },
      { "<leader>hS", desc = "Stage Buffer" },
      { "<leader>hu", desc = "Undo Stage Hunk" },
      { "<leader>hR", desc = "Reset Buffer" },
      { "<leader>hp", desc = "Preview Hunk" },
      { "<leader>hb", desc = "Blame Line" },
      { "<leader>hd", desc = "Diff This" },
      { "<leader>hD", desc = "Diff This ~" },
      
      { "<leader>t", group = "Toggle" },
      { "<leader>tb", desc = "Toggle Blame" },
      { "<leader>td", desc = "Toggle Deleted" },
      
      { "<leader>c", group = "Code" },
      { "<leader>ca", desc = "Code Action" },
      
      { "<leader>r", group = "Refactor" },
      { "<leader>rn", desc = "Rename" },
      
      { "<leader>e", desc = "Show Diagnostic" },
      { "<leader>q", desc = "Diagnostic Quickfix" },
    })
  end
}
  '';
}
