
{
  home.file.".config/nvim/lua/plugins/treesitter.lua".text =''
return {
"nvim-treesitter/nvim-treesitter",
event ="VeryLazy",
build =":TSUpdate",
config = function()
  local config = require("nvim-treesitter.configs")
  config.setup({
    auto_install = true,
    ensure_installed = { "lua", "python", "javascript", "typescript", "latex", "bibtex" },
    highlight = { enable = true },
    indent = { enable = true },
    sync_install = false,
  })
end
}
  '';
}
