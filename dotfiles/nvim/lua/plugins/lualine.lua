return {
  "nvim-lualine/lualine.nvim",
  event ="VeryLazy",
  config = function()
    require('lualine').setup({
      options = {
        theme = 'solarized_dark'
      }
    })
  end
}
