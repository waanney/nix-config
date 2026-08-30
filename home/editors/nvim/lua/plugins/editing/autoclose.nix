{
  config,
  pkgs,
  ...
}: {
  home.file.".config/nvim/lua/plugins/autoclose.lua".text = ''
    return {
    	{
    		"windwp/nvim-autopairs",
    		event = "InsertEnter",
    		config = true,
    		-- use opts = {} for passing setup options
    		-- this is equivalent to setup({}) function
    	},
    	{
    		"windwp/nvim-ts-autotag",
    		ft = { "html", "xml", "jsx", "tsx", "javascriptreact", "typescriptreact", "svelte", "vue" },
    		opts = {
    			opts = {
    				enable_close = true,
    				enable_rename = true,
    				enable_close_on_slash = false,
    			},
    			per_filetype = {
    				["html"] = {
    					enable_close = false,
    				},
    			},
    		},
    	},
    }
  '';
}
