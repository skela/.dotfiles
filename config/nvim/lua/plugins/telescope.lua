return {
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-dap.nvim",
			-- "nvim-telescope/telescope-media-files.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("dap")
				require("telescope").load_extension("rest")
				-- require("telescope").load_extension("media_files")
			end,
		},
		opts = {
			defaults = {
				-- wrap_results = true,
				-- sorting_strategy = "ascending",
				layout_config = {
					width = 0.98,
				},
				layout_strategy = "vertical",
				file_ignore_patterns = {
					"^.git/",
					"^node_modules/",
				},
				mappings = {
					n = {
						["<leader>cl"] = require("utils.ui").open_diagnostics,
					},
					i = {
						["<C-p>"] = require("telescope.actions.layout").toggle_preview,
						["<esc>"] = require("utils.ui").close_picker,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
					layout_strategy = "vertical",
				},
				live_grep = {
					only_sort_text = true,
					layout_strategy = "vertical",
				},
				diagnostics = {
					line_width = "full",
					layout_strategy = "vertical",
				},
			},
		},
	},
}
