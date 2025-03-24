return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		tag = "0.1.8", -- Có thể bỏ dòng này để dùng phiên bản mới nhất
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions.mt")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_down,
							["<C-k>"] = actions.move_selection_up,
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
						},
						n = {
							["<esc>"] = actions.close,
							["q"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = { no_ignore = true },
				},
			})

			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true }

			keymap("n", "<leader>rf", require("telescope.builtin").oldfiles, opts)
			keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
			keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
			keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
			keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
			-- test zone
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		event = "VeryLazy",
	},
}
