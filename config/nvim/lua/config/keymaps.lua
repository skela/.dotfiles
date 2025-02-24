-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
-- local unmap = vim.keymap.del

-- Don't ever start with leader in the map_common function, u dont want that in insert mode
local function map_common(combo, command, opts) map({ "n", "i", "x", "s" }, combo, command, opts) end

local function map_normal(combo, command, opts) map("n", combo, command, opts) end

local function map_visual(combo, command, opts) map("v", combo, command, opts) end

--@param s string
---@return string
local function cmd(s)
	if string.find(s, "<cr>") then
		return "<cmd>" .. s
	else
		return "<cmd>" .. s .. "<cr>"
	end
end

local keymaps = {}

keymaps.flutter = function(_, _) -- client,buffer
	map_normal("<leader>cO", cmd(":FlutterOutlineToggle"), { desc = "Property/Function [O]utline", remap = true })
	map_normal("<leader>cD", cmd(":FlutterDevices"), { desc = "[D]evices (Flutter)", remap = true })
	map_normal("<leader>cE", cmd(":FlutterEmulators"), { desc = "[E]mulators (Flutter)", remap = true })
	map_normal("<leader>ch", cmd(":FlutterReload"), { desc = "[h]ot Reload (Flutter)", remap = true })
	map_normal("<leader>cH", cmd(":FlutterRestart"), { desc = "[H]ot Restart (Flutter)", remap = true })
	map_normal("<leader>cL", cmd(":FlutterRun"), { desc = "[L]aunch (Flutter)", remap = true })
	map_normal("<leader>cQ", cmd(":FlutterQuit"), { desc = "[Q]uit (Flutter)", remap = true })
	map_normal("<leader>cv", cmd(":TermExec cmd='viewdroid -d' open=0"), { desc = "[v]iewdroid device (scrcpy)", remap = true })
	map_normal("<leader>cVd", cmd(":TermExec cmd='viewdroid -d' open=0"), { desc = "Viewdroid device (scrcpy)", remap = true })
	map_normal("<leader>cVe", cmd(":TermExec cmd='viewdroid -e' open=0"), { desc = "Viewdroid emulator (scrcpy)", remap = true })
	map_normal("<leader>cVq", cmd(":2TermExec cmd='killall scrcpy' open=0"), { desc = "Viewdroid quit (scrcpy)", remap = true })
	map_normal("<leader>cVt", cmd(":ToggleTerm"), { desc = "Viewdroid terminal", remap = true })
end

-- Coding
map({ "n", "v" }, "<C-K>", "gcc<esc>", { desc = "Comment selected line(s)", remap = true })
map_visual("<leader>.", "gc", { desc = "Comment selected text", remap = true })
map_normal("<leader>ut", cmd(":set list!"), { desc = "Toggle tabs indicator", remap = true })
map_normal("<leader>ct", cmd("TodoTelescope"), { desc = "List [t]odos", remap = true })
map_normal("<leader>cd", require("utils.ui").open_diagnostics, { desc = "List [d]iagnostics", remap = true })
map_normal("<leader>cs", cmd(":noa w"), { desc = "Save file without formatting", remap = true })

-- map("n", "<TAB>", ">>", { remap = true })
-- map("n", "<S-TAB>", "<<", { remap = true })
-- map("v", "<TAB>", "<S->>gv", { remap = true })
-- map("v", "<S-TAB>", "<S-<>gv", { remap = true })

-- Git
map_normal("<leader>gb", cmd(":Gitsigns toggle_current_line_blame"), { desc = "Toggle Blame", remap = true })

-- Files
map_common("<C-S>", cmd(":update<cr><esc>"), { desc = "Save file", remap = true })
map_normal("<leader>bs", cmd(":noa w"), { desc = "Save file without formatting", remap = true })
map_normal("<leader>ft", cmd("Telescope filetypes"), { desc = "Select filetype for buffer", remap = true })
map_normal("<leader>fF", require("utils.ui").search_all_files, { desc = "Search all files", remap = true })

-- Top Tabs
map_common("<A-Left>", cmd("BufferLineCyclePrev"), { desc = "Go to previous file", remap = true })
map_common("<A-Right>", cmd("BufferLineCycleNext"), { desc = "Go to next file", remap = true })
map_common("<A-Tab>", cmd("e #"), { desc = "Switch to Other file" })

-- General
map_common("<C-b>", cmd("Neotree toggle"), { desc = "Open filetree", remap = true })
map_common("<C-F>", require("utils.ui").search_current_file, { desc = "Search current file", remap = true })
map_common("\a", require("utils.ui").search_all_files, { desc = "Search all files", remap = true }) -- ctrl + shift + f work around for kitty
map_common("<C-p>", cmd("Telescope find_files"), { desc = "Jump to file", remap = true })
map_common("<C-t>", cmd("Telescope filetypes"), { desc = "Select filetype", remap = true })
map_normal("<leader>cos", cmd("e .env"), { desc = "Open [s]ecret .env file", remap = true })
map_normal("<leader>uS", cmd("Screenkey toggle"), { desc = "Toggle [S]creenkey", remap = true })

map_normal("<leader>nl", cmd("Lazy"), { desc = "Open [l]azy package manager", remap = true })
map_normal("<leader>nh", cmd("LazyHealth"), { desc = "Open lazy [h]ealth", remap = true })
map_normal("<leader>nm", cmd("Mason"), { desc = "Open [m]ason package manager", remap = true })
map_normal("<leader>nn", Snacks.notifier.show_history, { desc = "Open recent [n]otifications", remap = true })

return keymaps
