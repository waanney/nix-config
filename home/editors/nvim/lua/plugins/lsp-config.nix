
{home.file.".config/nvim/lua/plugins/lsp-config.lua".text =''

return {
	{
		"neovim/nvim-lspconfig",
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

			-- LSP Servers setup using new vim.lsp.config API
			vim.lsp.config("clangd", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("lua_ls", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("pyright", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("nil_ls", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("ts_ls", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("tailwindcss", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("texlab", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("jdtls", { capabilities = capabilities, on_attach = on_attach })
			vim.lsp.config("rust_analyzer", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					['rust-analyzer'] = {
						checkOnSave = {
							command = "clippy"
						},
					},
				},
			})

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
