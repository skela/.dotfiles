-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
-- local unmap = vim.keymap.del

local function mapCommon(combo, command, opts)
	map({ "n", "i", "x", "s" }, combo, command, opts)
end

local function mapNormal(combo, command, opts)
	map("n", combo, command, opts)
end

local function mapVisual(combo, command, opts)
	map("v", combo, command, opts)
end

--@param s string
---@return string
local function cmd(s)
	if string.find(s, "<cr>") then
		return "<cmd>" .. s
	else
		return "<cmd>" .. s .. "<cr>"
	end
end

--local toggleterm = require("custom.configs.toggleterm")

local keymaps = {}
keymaps.coding = function()
	mapNormal("<C-1>", cmd("TroubleToggle"), { desc = "Trouble & TODOs", remap = true })
	mapNormal("<leader>ct", cmd("TroubleToggle"), { desc = "Trouble & TODOs", remap = true })
end

keymaps.flutter = function(_, _) -- client,buffer
	keymaps.coding()
	mapNormal("<leader>cp", cmd(":FlutterOutlineToggle"), { desc = "Property/Function outline", remap = true })
	mapNormal("<leader>cd", cmd(":FlutterDevices"), { desc = "Devices (Flutter)", remap = true })
	mapNormal("<leader>ch", cmd(":FlutterReload"), { desc = "Hot Reload (Flutter)", remap = true })
	mapNormal("<leader>cR", cmd(":FlutterRestart"), { desc = "Restart (Flutter)", remap = true })
	mapNormal("<leader>cL", cmd(":FlutterRun"), { desc = "Launch (Flutter)", remap = true })
	mapNormal("<leader>cQ", cmd(":FlutterQuit"), { desc = "Quit (Flutter)", remap = true })
	-- mapNormal("<leader>cL", ":split | buffer __FLUTTER_DEV_LOG__<CR>", { remap = false, desc = "Open flutter dev log in horizontal split" })
end

-- Coding
map({ "n", "v" }, "<C-K>", "gcc<esc>", { desc = "Comment selected line(s)", remap = true })
mapVisual("<leader>.", "gc", { desc = "Comment selected text", remap = true })
keymaps.coding()

-- Files
mapCommon("<C-S>", cmd(":update<cr><esc>"), { desc = "Save file", remap = true })
mapCommon("<C-W>", cmd(":bp<bar>sp<bar>bn<bar>bd"), { desc = "Close file", remap = true })
mapNormal("<C-n>", cmd("enew"), { desc = "New File" })

-- Top Tabs
mapCommon("<A-Left>", cmd("BufferLineCyclePrev"), { desc = "Go to previous file", remap = true })
mapCommon("<A-Right>", cmd("BufferLineCycleNext"), { desc = "Go to next file", remap = true })
mapCommon("<A-Tab>", cmd("e #"), { desc = "Switch to Other file" })

-- General
mapCommon("<C-b>", cmd("Neotree toggle"), { desc = "Open filetree", remap = true })
mapCommon("<C-F>", cmd("Telescope current_buffer_fuzzy_find"), { desc = "Search current file", remap = true })
mapCommon("<C-p>", cmd("Telescope find_files hidden=true"), { desc = "Jump to file", remap = true })
mapCommon("<C-S-f>", cmd("Telescope live_grep"), { desc = "Search all files", remap = true })

return keymaps
