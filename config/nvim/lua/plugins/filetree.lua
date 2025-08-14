local Util = require("lazyvim.util")

return {
	"nvim-neo-tree/neo-tree.nvim",
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
			"<leader>fe",
			function() require("neo-tree.command").execute({ toggle = true, dir = Util.root() }) end,
			desc = "Explorer NeoTree (root dir)",
		},
		{
			"<leader>fE",
			function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end,
			desc = "Explorer NeoTree (cwd)",
		},
		{ "<leader>E", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
		{ "<leader>e", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
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
