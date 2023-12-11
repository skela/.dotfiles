return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"pyright",
				"rust-analyzer",
				"dart-debug-adapter",
				-- "table",
				"codelldb",
			},
		},
	},
}
