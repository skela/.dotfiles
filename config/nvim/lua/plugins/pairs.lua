return {
	{ "echasnovski/mini.pairs", enabled = false },
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding so if u want to replace ' with " type gsr'"
				update_n_lines = "gsn", -- Update `n_lines`
			},
		},
	},
}
