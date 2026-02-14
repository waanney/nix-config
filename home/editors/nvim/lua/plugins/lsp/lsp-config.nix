
{home.file.".config/nvim/lua/plugins/lsp-config.lua".text =''

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
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
				if client.supports_method("textDocument/formatting") then
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

			-- Common LSP servers (loaded on BufReadPre/BufNewFile)
			vim.lsp.config("lua_ls", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("nil_ls", { capabilities = capabilities, on_attach = on_attach })

			-- Filetype-specific LSP servers (lazy-loaded)
			local lsp_filetypes = {
				{ ft = { "c", "cpp", "h", "hpp" }, server = "clangd" },
				{ ft = { "python" }, server = "pyright" },
				{ ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, server = "ts_ls" },
				{ ft = { "html", "css", "javascriptreact", "typescriptreact" }, server = "tailwindcss" },
				{ ft = { "tex", "plaintex", "latex", "bib" }, server = "texlab" },
				{ ft = { "java" }, server = "jdtls" },
				{ ft = { "rust" }, server = "rust_analyzer", settings = {
					['rust-analyzer'] = {
						checkOnSave = {
							command = "clippy"
						},
					},
				}},
			}

			for _, config in ipairs(lsp_filetypes) do
				vim.api.nvim_create_autocmd("FileType", {
					pattern = config.ft,
					callback = function()
						if config.settings then
							vim.lsp.config(config.server, {
								capabilities = capabilities,
								on_attach = on_attach,
								settings = config.settings
							})
						else
							vim.lsp.config(config.server, { capabilities = capabilities, on_attach = on_attach })
						end
						vim.cmd("LspStart " .. config.server)
					end,
				})
			end

			-- Keybindings
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
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
