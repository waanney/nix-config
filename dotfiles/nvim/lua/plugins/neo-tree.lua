return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
				},
        show_hidden = true,
			},
		})
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
	end,
}
