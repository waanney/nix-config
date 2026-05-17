
{home.file.".config/nvim/lua/plugins/lsp-config.lua".text =''

return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		priority = 1000,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
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

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Format on save
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
			local on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end

			-- Suppress lspconfig deprecation warnings for Neovim 0.12+
			vim.g.lspconfig_silent = 1

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
					on_attach = on_attach,
				}

				if lsp == "rust_analyzer" then
					opts.settings = {
						["rust-analyzer"] = {
							checkOnSave = {
								command = "clippy",
							},
						},
					}
				end

				-- Ultra-safe setup: index within pcall to catch __index errors
				pcall(function()
					if lspconfig[lsp] then
					lspconfig[lsp].setup(opts)
					end
				end)
			end

			-- Keybindings
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "grr", vim.lsp.buf.references, { desc = "LSP References" })
			vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, {})
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {})
		end,
	},
}
    '';
}
