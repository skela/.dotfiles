return {
	"rest-nvim/rest.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
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
			-- env_pattern = "\\.env$",
		})
	end,
}
