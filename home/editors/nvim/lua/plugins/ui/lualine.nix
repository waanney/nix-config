
{
  home.file.".config/nvim/lua/plugins/lualine.lua".text =''
return {
  "nvim-lualine/lualine.nvim",
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
