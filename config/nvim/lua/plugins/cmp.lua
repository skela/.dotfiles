return {
	{
		-- https://github.com/saghen/blink.cmp?tab=readme-ov-file#configuration
		"saghen/blink.cmp",
		version = "v0.7.6",
		dependencies = "rafamadriz/friendly-snippets",
		-- event = "InsertEnter",
		opts = {
			keymap = {
				preset = "default",
				-- ["<Right>"] = { "select_and_accept", "fallback" },
				["<Right>"] = { "accept", "fallback" },

				-- preset = "default",
				-- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				-- ["<C-e>"] = { "hide", "fallback" },
				-- ["<CR>"] = {},
				-- ["<C-y>"] = { "select_and_accept", "fallback" },
				-- ["<Right>"] = { "select_and_accept", "fallback" },
				--
				-- ["<Tab>"] = { "snippet_forward", "fallback" },
				-- ["<S-Tab>"] = { "snippet_backward", "fallback" },
				--
				-- ["<Up>"] = { "select_prev", "fallback" },
				-- ["<Down>"] = { "select_next", "fallback" },
				-- ["<C-p>"] = { "select_prev", "fallback" },
				-- ["<C-n>"] = { "select_next", "fallback" },
				--
				-- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
				-- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			list = {
				selection = "manual",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				-- optionally disable cmdline completions
				-- cmdline = {},
			},
		},
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
}
