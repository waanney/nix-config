{
  home.file.".config/nvim/lua/plugins/lsp-config.lua".text = ''
    return {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "''${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        init = function()
          -- Tắt cảnh báo deprecation trên Neovim 0.11+
          vim.g.lspconfig_silent = 1
        end,
        dependencies = {
          "Saghen/blink.cmp",
        },
        config = function()
          -- Configure diagnostics
          vim.diagnostic.config({
            virtual_text = {
              prefix = "●",
              source = "if_many",
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
              border = "rounded",
              source = "always",
              header = "",
              prefix = "",
            },
          })

          local capabilities = require("blink.cmp").get_lsp_capabilities()
          local lspconfig = require("lspconfig")

          -- LSP servers setup
          local servers = {
            "lua_ls",
            "nil_ls",
            "clangd",
            "pyright",
            "ts_ls",
            "tailwindcss",
            "texlab",
            "jdtls",
            "rust_analyzer",
          }

          for _, lsp in ipairs(servers) do
            local opts = {
              capabilities = capabilities,
            }

            if lsp == "rust_analyzer" then
              opts.settings = {
                ["rust-analyzer"] = {
                  checkOnSave = {
                    command = "clippy",
                  },
                },
              }
            elseif lsp == "texlab" then
              opts.settings = {
                texlab = {
                  build = {
                    onSave = false, -- Đã có VimTeX build, tắt để không bị build 2 lần
                  },
                  chktex = {
                    onEdit = false, -- Tắt linting liên tục khi gõ phím để chống lag
                    onOpen = false,
                  },
                  diagnosticsDelay = 500,
                },
              }
            end

            -- Hỗ trợ cả Neovim 0.11+ (vim.lsp.config) lẫn Neovim cũ (lspconfig.setup)
            if vim.lsp.config and vim.lsp.enable then
              vim.lsp.config[lsp] = opts
              vim.lsp.enable(lsp)
            else
              pcall(function()
                if lspconfig[lsp] then
                  lspconfig[lsp].setup(opts)
                end
              end)
            end
          end

          -- Keybindings
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
          vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "LSP References" })
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic Float" })
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic Location List" })
        end,
      },
    }
  '';
}
