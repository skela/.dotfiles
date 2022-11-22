
local utils = require("skela.utils")

local flutter = utils.require_safely("flutter-tools")
if not flutter then return end

local keymapper = require("skela.keymaps")

flutter.setup
{
	lsp = {
		on_attach = keymapper.lsp_on_attach
	}
}
