
{
  home.file.".config/nvim/lua/plugins/telescope.lua".text =''

return {
{
  'nvim-telescope/telescope.nvim',
  cmd = "Telescope",
  keys = {
    { '<C-p>', desc = "Find Files" },
    { '<leader>fg', desc = "Live Grep" },
    { '<leader>fb', desc = "Buffers" },
    { '<leader>fh', desc = "Help Tags" },
    { '<leader>fs', desc = "Grep String" },
    { '<leader>fo', desc = "Old Files" },
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require("telescope.builtin")
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "target/",
          "%.lock",
          "__pycache__",
          "%.pyc",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })
    -- File navigation
    vim.keymap.set('n', '<C-p>', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
  end
},
{
  'nvim-telescope/telescope-ui-select.nvim',
  event = "VeryLazy",
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require("telescope").setup {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {}
        }
      }
    }
    require("telescope").load_extension("ui-select")
  end
}
}
  '';
}
