return {
	{
		"akinsho/nvim-toggleterm.lua",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = "1",
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})
		end,
	},
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
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
		init = function() vim.g.mkdp_browser = "firefox-developer-edition" end,
	},
}
