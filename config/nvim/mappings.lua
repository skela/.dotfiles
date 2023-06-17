local M = {}

---@param s string
---@return string
local function cmd(s)
	return "<cmd>" .. s .. "<cr>"
end

local cmds = {}
cmds.save_file = {cmd(":update"), "Save file"}
cmds.close_file = {cmd(":bp<bar>sp<bar>bn<bar>bd"), "Close file"}
cmds.open_file_tree = {cmd(":NvimTreeToggle"),"Open filetree"}
cmds.search_file = {cmd("Telescope current_buffer_fuzzy_find"),"Search current file"}
cmds.find_files = {cmd("Telescope find_files hidden=true"),"Jump to file"}
cmds.search_all_files = {cmd("Telescope live_grep"),"Search all files"}

M.general = {
	n = {
		["<C-b>"] = cmds.open_file_tree,
		["<C-S>"] = cmds.save_file,
		["<C-W>"] = cmds.close_file,
		["<C-F>"] = cmds.search_file,
		["<C-p>"] = cmds.find_files,
		["<C-S-f>"] = cmds.search_all_files,
		["<leader>?"] = {cmd("Telescope oldfiles"),"Find recently opened files"},
		["<leader><leader>"] = {cmd("Telescope buffers"),"Find existing buffers"},
		["<leader>d"] = {cmd("Telescope diagnostics"),"Diagnostics"},
	},

	i = {
		["<C-b>"] = cmds.open_file_tree,
		["<C-S>"] = cmds.save_file,
		["<C-W>"] = cmds.close_file,
		["<C-F>"] = cmds.search_file,
		["<C-p>"] = cmds.find_files,
		["<C-S-f>"] = cmds.search_all_files,
	},
}

return M
