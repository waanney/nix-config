{
  home.file.".config/nvim/lua/plugins/completions.lua".text = ''
    return {
      {
        "Saghen/blink.cmp",
        event = "InsertEnter",
        dependencies = {
          "rafamadriz/friendly-snippets",
        },
        version = "*",
        build = "cargo build --release",
        opts = {
          keymap = {
            preset = "default",
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
          },
          appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
          },
          sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            per_filetype = {
              tex = { "lsp", "snippets" },
              plaintex = { "lsp", "snippets" },
              markdown = { "lsp", "path", "snippets" },
            },
            providers = {
              buffer = {
                min_keyword_length = 3,
                score_offset = -3,
              },
            },
          },
          signature = {
            enabled = true,
          },
          completion = {
            menu = {
              border = "rounded",
            },
            documentation = {
              window = {
                border = "rounded",
              },
              auto_show = true,
              auto_show_delay_ms = 200,
            },
          },
        },
        opts_extend = { "sources.default" },
      },
    }
  '';
}
