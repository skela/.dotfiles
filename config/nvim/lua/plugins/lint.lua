return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				fish = { "fish" },
				markdown = { "markdownlint-cli2" },
			},
			events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		},
		config = function()
			local markdownlint = require("lint").linters.markdownlint
			markdownlint.args = {
				"--disable",
				"MD013",
				"--",
			}
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.markdownlint_cli2.with({
						extra_args = { "--config", vim.fn.stdpath("config") .. "/markdownlint-cli2.yaml" },
					}),
				},
			})
		end,
	},
}
