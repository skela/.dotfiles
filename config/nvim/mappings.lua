local M = {}

---@param s string
---@return string
local function cmd(s)
	return "<cmd>" .. s .. "<cr>"
end

local cmds = {}
cmds.save_file = cmd(":update")

M.general = {
	n = {
		["<C-b>"] = {cmd(":NvimTreeToggle"),"Open filetree"},
		["<C-S>"] = {cmds.save_file, "Save file"},
		["<C-F>"] = {cmd("Telescope current_buffer_fuzzy_find"),"Search current file"},
		["<C-p>"] = {cmd("Telescope find_files hidden=true"),"Jump to file"},
		["<C-S-f>"] = {cmd("Telescope live_grep"),"Search all files"},
		["<leader>?"] = {cmd("Telescope oldfiles"),"Find recently opened files"},
		["<leader><leader>"] = {cmd("Telescope buffers"),"Find existing buffers"},
		["<leader>d"] = {cmd("Telescope diagnostics"),"Diagnostics"},
	},

	i = {
		["<C-S>"] = {cmds.save_file, "Save file"},
	},
}

return M
