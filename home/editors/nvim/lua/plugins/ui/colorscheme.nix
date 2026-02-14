{
  home.file.".config/nvim/lua/plugins/colorscheme.lua".text =''
return{
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
    vim.cmd[[colorscheme solarized-osaka]]
    end,

  },
}
    '';
}
