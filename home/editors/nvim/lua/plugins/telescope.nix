
{
  home.file.".config/nvim/lua/plugins/telescope.lua".text =''

return {
{
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require("telescope.builtin")
    require("telescope").setup({
      defaults = {
        -- You can set defaults here if you want
      },
      pickers = {
        find_files = {
          hidden = true, -- This line tells Telescope to show hidden files (dotfiles)
          -- Other find_files options can go here
        },
      },
    })
    vim.keymap.set('n', '<C-p>', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  end
},
{
  'nvim-telescope/telescope-ui-select.nvim',
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
