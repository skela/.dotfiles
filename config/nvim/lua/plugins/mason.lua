return {
	{
		"williamboman/mason.nvim",
		keys = {},
		opts = {
			ensure_installed = {
				"biome",
				"codelldb",
				"dart-debug-adapter",
				"debugpy",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"gofumpt",
				"goimports",
				"gopls",
				"hadolint",
				"js-debug-adapter",
				"kotlin-debug-adapter",
				"kotlin-language-server",
				"lua-language-server",
				"omnisharp",
				"prettier",
				"pyright",
				"rust-analyzer",
				"shellcheck",
				"shfmt",
				"stylua",
				"vtsls",
				"yapf",
				"zls",
			},
		},
	},
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		local nls = require("null-ls")
	-- 		opts.sources = opts.sources or {}
	-- 		table.insert(opts.sources, nls.builtins.formatting.prettier, nls.builtins.formatting.yapf)
	-- 	end,
	-- },
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		local nls = require("null-ls")
	-- 		opts.sources = opts.sources or {}
	-- 		table.insert(opts.sources, nls.builtins.formatting.prettier)
	-- 	end,
	-- },
}
