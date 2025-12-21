return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
		close_if_last_window = true,
		event_handlers = {
			{
				event = "file_opened",
				handler = function() require("neo-tree.command").execute({ action = "close" }) end,
			},
		},
		source_selector = {
			winbar = false,
			statusline = false,
		},
		window = {
			position = "right",
			width = 60,
		},
	},
	keys = {
		{
			"<leader>e",
			function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end,
			desc = "Explorer NeoTree (cwd)",
		},
		{
			"<leader>ge",
			function() require("neo-tree.command").execute({ source = "git_status", toggle = true }) end,
			desc = "Git explorer",
		},
		{
			"<leader>be",
			function() require("neo-tree.command").execute({ source = "buffers", toggle = true }) end,
			desc = "Buffer explorer",
		},
	},
}
