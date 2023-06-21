
local options = require "custom.configs.opts"

local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = options.treesitter,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require "plugins.configs.lspconfig"
			require "custom.configs.lspconfig"
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = options.mason,
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = options.telescope,
	},
	{
		"akinsho/toggleterm.nvim",
		opts = options.toggleterm,
		lazy = false,
	},
}
return plugins
