local utils = require("skela.utils")
local fterm = utils.require_safely("FTerm")
if not fterm then return end

fterm.setup
{
	border = "single",
	dimensions = {
		height = 0.9,
		width = 0.9,
	},
	blend = 10
}

