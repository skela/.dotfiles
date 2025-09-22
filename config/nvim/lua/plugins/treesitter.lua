return {

	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- add tsx and treesitter
			vim.list_extend(opts.ensure_installed, {
				"sh",
				"bash",
				"fish",
				"html",
				"javascript",
				"json",
				"hjson",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
				"dart",
				"swift",
				"rust",
				"css",
				"kotlin",
				"dockerfile",
				"http",
				"xml",
				"graphql",
				-- "pkl",
				"http",
				"zig",
				-- "openscad",
			})
			vim.list_extend(opts.indent, {
				enable = true,
				disable = { "dart", "swift", "rust" },
			})
			vim.treesitter.language.register("bash", "dotenv")
		end,
	},
}
