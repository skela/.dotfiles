return {
	{
		"mg979/vim-visual-multi",
		lazy = false,
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-n>",
				["Add Cursor Down"] = "<C-Down>",
				["Add Cursor Up"] = "<C-Up>",
				-- ["Add Cursor Down"] = "<A-Down>",
				-- ["Add Cursor Up"] = "<A-Up>",
			}
		end,
	},
}
