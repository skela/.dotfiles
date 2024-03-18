return {
	{
		"vhyrro/luarocks.nvim",
		config = function() require("luarocks").setup({}) end,
	},
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"luarocks.nvim",
		},
		config = function()
			require("rest-nvim").setup({
				result = {
					formatters = {
						json = "jq",
						problem = "jq",
						html = function(body) return vim.fn.system({ "tidy", "-i", "-q", "-" }, body) end,
					},
				},
				env_pattern = "\\.http.env$",
				keybinds = {
					{
						"<leader>rr",
						"<cmd>Rest run<cr>",
						"[r]un http request",
					},
					{
						"<leader>rl",
						"<cmd>Rest run last<cr>",
						"Re-run latest request",
					},
				},
			})
		end,
	},
}
