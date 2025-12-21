return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>t", group = "+test", icon = { icon = "󰙨" } },
				{ "<leader>r", group = "+run", icon = { icon = "" } },
				{ "<leader>h", group = "+harpoon", icon = { icon = "󰛢" } },
				{ "<leader>co", group = "+open", icon = { icon = "" } },
				{ "<leader>cV", group = "+viewdroid", icon = { icon = "" } },
				{ "<leader>n", group = "+neovim", icon = { icon = "" } },
			},
		},
	},
}
