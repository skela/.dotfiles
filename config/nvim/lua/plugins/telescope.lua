local actions = require("telescope.actions")
return {
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-dap.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("dap")
			end,
		},
		opts = {
			defaults = {
				-- wrap_results = true,
				-- sorting_strategy = "ascending",
				file_ignore_patterns = {
					"^.git/",
					"^node_modules/",
				},
				mappings = {
					i = {
						["<C-p>"] = require("telescope.actions.layout").toggle_preview,
						["<esc>"] = actions.close,
					},
				},
			},
			pickers = {
				live_grep = {
					only_sort_text = true,
				},
				diagnostics = {
					line_width = "full",
					layout_strategy = "vertical",
				},
			},
		},
	},
}
