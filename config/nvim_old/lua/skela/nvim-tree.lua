local utils = require("skela.utils")
local tree = utils.require_safely("nvim-tree")
if not tree then return end

local keymapper = require("skela.keymaps")

tree.setup
{
	view = {
		mappings = keymapper.nvim_tree()
	}
}
