-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
-- local unmap = vim.keymap.del

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
keymaps.coding = function()
	map_normal("<C-i>", cmd(":Telescope diagnostics"), { desc = "Trouble & TODOs", remap = true })
	map_normal("<leader>ct", cmd(":Telescope diagnostics"), { desc = "Trouble & TODOs", remap = true })
	-- vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts) -- opens current error warning in a float
end

keymaps.flutter = function(_, _) -- client,buffer
	keymaps.coding()
	map_normal("<leader>cp", cmd(":FlutterOutlineToggle"), { desc = "Property/Function outline", remap = true })
	map_normal("<C-o>", cmd(":FlutterOutlineToggle"), { desc = "Property/Function outline", remap = true })
	map_normal("<leader>cd", cmd(":FlutterDevices"), { desc = "Devices (Flutter)", remap = true })
	map_normal("<leader>ch", cmd(":FlutterReload"), { desc = "Hot Reload (Flutter)", remap = true })
	map_normal("<leader>cR", cmd(":FlutterRestart"), { desc = "Restart (Flutter)", remap = true })
	map_normal("<leader>cL", cmd(":FlutterRun"), { desc = "Launch (Flutter)", remap = true })
	map_normal("<leader>cQ", cmd(":FlutterQuit"), { desc = "Quit (Flutter)", remap = true })
	-- mapNormal("<leader>cL", ":split | buffer __FLUTTER_DEV_LOG__<CR>", { remap = false, desc = "Open flutter dev log in horizontal split" })
end

map({ "i", "s" }, "<Tab>", function()
	require("cmp").mapping(function(fallback)
		if require("cmp").visible() then
			require("cmp").select_next_item()
		elseif require("luasnip").expand_or_jumpable() then
			require("luasnip").expand_or_jump()
		else
			fallback()
		end
	end)
end)

-- Coding
map({ "n", "v" }, "<C-K>", "gcc<esc>", { desc = "Comment selected line(s)", remap = true })
map_visual("<leader>.", "gc", { desc = "Comment selected text", remap = true })
keymaps.coding()

-- Files
map_common("<C-S>", cmd(":update<cr><esc>"), { desc = "Save file", remap = true })
map_common("<C-W>", cmd(":bd"), { desc = "Close file", remap = true })
map_normal("<leader>ft", cmd("Telescope filetypes"), { desc = "Select filetype for buffer", remap = true })
map_normal("<leader>fF", cmd("Telescope live_grep"), { desc = "Search all files", remap = true })

-- Top Tabs
map_common("<A-Left>", cmd("BufferLineCyclePrev"), { desc = "Go to previous file", remap = true })
map_common("<A-Right>", cmd("BufferLineCycleNext"), { desc = "Go to next file", remap = true })
map_common("<A-Tab>", cmd("e #"), { desc = "Switch to Other file" })

-- General
map_common("<C-b>", cmd("Neotree toggle"), { desc = "Open filetree", remap = true })
map_common("<C-F>", cmd("Telescope current_buffer_fuzzy_find"), { desc = "Search current file", remap = true })
map_common("\a", cmd("Telescope live_grep"), { desc = "Search all files", remap = true }) -- ctrl + shift + f work around for kitty
map_common("<C-p>", cmd("Telescope find_files hidden=true"), { desc = "Jump to file", remap = true })
map_common("<C-t>", cmd("Telescope filetypes"), { desc = "Select filetype", remap = true })
map_normal("<leader>tf", cmd("Telescope current_buffer_fuzzy_find"), { desc = "Search current file", remap = true })
map_normal("<leader>tF", cmd("Telescope live_grep"), { desc = "Search all files", remap = true })

return keymaps
