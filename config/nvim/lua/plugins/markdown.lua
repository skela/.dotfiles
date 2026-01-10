return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
			bullet = {
				icons = { "•", "◦", "▪" },
				right_pad = 1,
			},
			checkbox = {
				unchecked = { icon = "󰄱" },
				checked = { icon = "󰱒" },
				custom = {},
			},
		},
		ft = { "markdown", "Avante" },
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		--   "BufReadPre path/to/my-vault/**.md",
		--   "BufNewFile path/to/my-vault/**.md",
		-- },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "notes",
					path = "~/documents/notes",
				},
			},
		},
	},
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	ft = { "markdown" },
	-- 	build = function() vim.fn["mkdp#util#install"]() end,
	-- 	init = function() vim.g.mkdp_browser = "firefox-developer-edition" end,
	-- },
}
