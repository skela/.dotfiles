local M = {}

---@param s string
---@return string
local function cmd(s)
	if string.find(s,"<cr>") then
		return "<cmd>" .. s
	else
		return "<cmd>" .. s .. "<cr>"
	end
end

local function next_file()
	require("nvchad.tabufline").tabuflineNext()
end

local function previous_file()
	require("nvchad.tabufline").tabuflinePrev()
end

local toggleterm = require("custom.configs.toggleterm")

local cmds = {}
cmds.save_file = {cmd(":update<cr><esc>"), "Save file"}
cmds.close_file = {cmd(":bp<bar>sp<bar>bn<bar>bd"), "Close file"}
cmds.open_file_tree = {cmd(":NvimTreeToggle"),"Open filetree"}
cmds.search_file = {cmd("Telescope current_buffer_fuzzy_find"),"Search current file"}
cmds.find_files = {cmd("Telescope find_files hidden=true"),"Jump to file"}
cmds.search_all_files = {cmd("Telescope live_grep"),"Search all files"}
cmds.previous_file = {previous_file,"Go to previous file"}
cmds.next_file = {next_file,"Go to next file"}
cmds.plugins_update_mason = {cmd(":MasonInstallAll"),"Update Mason"}
cmds.plugins_update_treesitter = {cmd(":TSUpdateSync"),"Update Treesitter"}

local common = {
	["<C-b>"] = cmds.open_file_tree,
	["<C-S>"] = cmds.save_file,
	["<C-W>"] = cmds.close_file,
	["<C-F>"] = cmds.search_file,
	["<C-p>"] = cmds.find_files,
	["<C-S-f>"] = cmds.search_all_files,
	["<A-Left>"] = cmds.previous_file,
	["<A-Right>"] = cmds.next_file,
}

M.general = {
	n = {
		["<leader>?"] = {cmd("Telescope oldfiles"),"Find recently opened files"},
		["<leader><leader>"] = {cmd("Telescope buffers"),"Find existing buffers"},
		["<leader>d"] = {cmd("Telescope diagnostics"),"Diagnostics"},
		["<leader>t1"] = {cmd("1:ToggleTerm"), "Terminal 1"},
		["<leader>t2"] = { toggleterm.toggle2, "Terminal 2" },
		["<leader>t3"] = { toggleterm.toggle3, "Terminal 3 (Git History)" },
		["<leader>gh"] = { toggleterm.toggle3, "Git History" },
		["<leader>pm"] = cmds.plugins_update_mason,
		["<leader>pt"] = cmds.plugins_update_treesitter,
	},

	i = {
	},
}

for k, v in pairs(common) do
	M.general.n[k] = v
	M.general.i[k] = v
end

return M
