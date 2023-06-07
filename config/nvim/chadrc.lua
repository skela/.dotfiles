---@type ChadrcConfig 
local M = {}
M.ui = {
	changed_themes = {
		gruvbox = {
			base_16 = { base00 = "#000000" },
			base_30 = { black = "#000000" },
			base_46 = { black = "#000000" },
		},
	},
	theme = "gruvbox",
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
return M
