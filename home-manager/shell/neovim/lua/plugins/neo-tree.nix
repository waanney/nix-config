
{
  home.file.".config/nvim/lua/plugins/neo-tree.lua".text =''
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
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
    vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', {})
  end
}
    '';
}
