
local utils = require("skela.utils")
local commented = utils.require_safely("commented")
if not commented then return end

commented.setup
{
	comment_padding = " ",
	prefer_block_comment = false,
	set_keybindings = false,
}
