
{
  home.file.".config/nvim/lua/plugins/treesitter.lua".text =''
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- Kiểm tra xem module cũ còn tồn tại không để tránh crash
    local status, configs = pcall(require, "nvim-treesitter.configs")
    if status then
      configs.setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "latex", "bibtex", "java", "rust", "nix", "html", "yaml", "markdown", "markdown_inline", "bash" },
        highlight = { enable = true },
        indent = { enable = true },
        sync_install = true,
        auto_install = true, 
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },
      })
    end
    -- If using treesitter v1.0+, it uses defaults automatically
    -- Nix will handle grammar installation through package management
  end,
}
  '';
}
