{
  home.file.".config/nvim/lua/plugins/completions.lua".text =''

return {
  {
    'hrsh7th/cmp-nvim-lsp'
  },
  {
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets"
		},
		config = function()
			-- Load snippets lazily from friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
    event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			-- Snippets are already loaded in LuaSnip config above
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					-- Tab navigation
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "obsidian" },       -- Obsidian wiki-link completion
					{ name = "obsidian_new" },   -- Obsidian new note completion
					{ name = "obsidian_tags" },  -- Obsidian tag completion
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
    '';
}
