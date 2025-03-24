return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"tailwindcss",
					"ts_ls",
          "html",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			-- autocomplete for language you want
			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.clangd.setup({ capabilities = capabilities })
			lspconfig.tailwindcss.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.html.setup({capabilities = capabilities})
	end,
	},
}
