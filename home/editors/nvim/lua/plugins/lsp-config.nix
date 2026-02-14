
{home.file.".config/nvim/lua/plugins/lsp-config.lua".text =''

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Configure diagnostics
			vim.diagnostic.config({
				virtual_text = {
					prefix = '●',
					source = "if_many",
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = 'rounded',
					source = 'always',
					header = '',
					prefix = '',
				},
			})

			-- Diagnostic signs
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			local lsp_config = require("lspconfig")
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

			-- LSP Servers setup
			lsp_config.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.nil_ls.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.ts_ls.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.texlab.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.jdtls.setup({ capabilities = capabilities, on_attach = on_attach })
			lsp_config.rust_analyzer.setup({
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
			vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, {})
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {})
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {})
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {})
		end,
	},
}
    '';
}
