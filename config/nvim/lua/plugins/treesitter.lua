return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
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
			},
			indent = {
				enable = true,
				disable = { "dart", "swift", "rust" },
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.treesitter.language.register("bash", "dotenv")
		end,
		build = ":TSUpdate",
	},
}
