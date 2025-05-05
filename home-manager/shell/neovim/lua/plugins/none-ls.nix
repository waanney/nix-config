{
  home.file.".config/nvim/lua/plugins/none-ls.lua".text =''

return {
"nvimtools/none-ls.nvim",
event ="VeryLazy",
config = function()
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
    },
  })

  vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
end,
}
  '';

}
