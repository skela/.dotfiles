local M = {}

M.general = {
	n = {
		["<C-b>"] = {"<cmd>:NvimTreeToggle<CR>","Open filetree"},
		["<C-S>"] = {"<cmd>:update<CR>", "Save file"},
		["<C-F>"] = {"<cmd>Telescope current_buffer_fuzzy_find<CR>","Search current file"},
		["<C-p>"] = {"<cmd>Telescope find_files hidden=true<CR>","Jump to file"},
	},

	i = {
		["<C-S>"] = {"<cmd>:update<CR>", "Save file"},
	},
}

return M
