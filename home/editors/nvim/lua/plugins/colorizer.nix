{
  home.file.".config/nvim/lua/plugins/colorizer.lua".text =''
return {
  "norcalli/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require('colorizer').setup({
      '*',
      css = { rgb_fn = true },
      html = { names = false },
    }, {
      RGB      = true,
      RRGGBB   = true,
      names    = true,
      RRGGBBAA = true,
      rgb_fn   = true,
      hsl_fn   = true,
      css      = true,
      css_fn   = true,
      mode     = 'background',
    })
  end
}
  '';
}
