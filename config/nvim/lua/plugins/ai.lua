return {
	{
		"jackMort/ChatGPT.nvim",
		enabled = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup({
				api_key_cmd = require("utils.env").load_variable("~/.dotfiles/private/.env", "CHATGPT_APIKEY"),
			})
		end,
	},
}
