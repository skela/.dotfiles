
local T = {}

T.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"javascript",
		"tsx",
		"json",
		"hjson",
		"swift",
		"dart",
		"dockerfile",
		"python",
		"markdown",
		"bash",
		"fish",
	},
}

T.mason = {
	ensure_installed = {
		"rust-analyzer",
		"pyright",
	},
}

T.telescope = {
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		}
	}
}

T.toggleterm = {
	size = 20,
	open_mapping = [[<c-\>]],
	on_open = function(t) require("custom.configs.toggleterm").on_term_open(t) end,
	on_close = function(t) require("custom.configs.toggleterm").on_term_close(t) end,
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	count = 1,
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
}

return T
