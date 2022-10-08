
local utils = require("skela.utils")
local keymapper = require("skela.keymaps")

local flutter = utils.require_safely("flutter-tools")
if not flutter then return end

flutter.setup
{
	lsp = {
		on_attach = keymapper.lsp_on_attach
	}
}

