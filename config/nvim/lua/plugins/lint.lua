return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				fish = { "fish" },
				markdown = { "markdownlint-cli2" },
			},
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
			linters = {
				["markdownlint-cli2"] = {
					args = { "--config", "~/.dotfiles/config/markdownlint-cli2.yaml", "--" },
				},
			},
		},
		-- config = function()
		-- 	local markdownlint = require("lint").linters.markdownlint
		-- 	markdownlint.args = {
		-- 		"--disable",
		-- 		"MD013",
		-- 		"--", -- Required
		-- 	}
		-- end,
	},
}
