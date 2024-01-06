return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"pyright",
				"debugpy",
				"rust-analyzer",
				"dart-debug-adapter",
				-- "table",
				"codelldb",
				-- "sourcekit",
			},
		},
	},
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
