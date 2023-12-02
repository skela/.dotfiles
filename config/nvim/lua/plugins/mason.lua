return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				--"flake8",
				"pyright",
				"rust-analyzer",
				"dart-debug-adapter",
			},
		},
	},
}
