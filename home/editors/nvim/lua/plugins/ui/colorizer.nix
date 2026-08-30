{
  home.file.".config/nvim/lua/plugins/colorizer.lua".text = ''
    return {
      "NvChad/nvim-colorizer.lua",
      event = "VeryLazy",
      config = function()
        require('colorizer').setup({
          filetypes = { "css", "scss", "html", "javascriptreact", "typescriptreact" },
          user_default_options = {
            RGB      = true,
            RRGGBB   = true,
            names    = true,
            RRGGBBAA = true,
            AARRGGBB = false,
            rgb_fn   = true,
            hsl_fn   = true,
            css      = true,
            css_fn   = true,
            mode     = 'background',
            tailwind = true,
            sass     = { enable = true, parsers = { "css" } },
            virtualtext = "■",
          },
          buftypes = {},
        })
      end
    }
  '';
}
