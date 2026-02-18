
{
  home.file.".config/nvim/lua/plugins/lualine.lua".text =''
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    require('lualine').setup({
      options = {
        theme = 'dracula'
      }
    })
  end
}
    '';
}
