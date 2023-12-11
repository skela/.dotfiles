-- local keymaps = function()
-- 	return require("config.keymaps").rust()
-- end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"simrat39/rust-tools.nvim",
		},
		opts = {
			servers = {
				pyright = {},
				rust_analyzer = {
					-- keys = require("config.keymaps").rust(),
					-- keys = keymaps(),
					keys = {
						{ "<leader>cD", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
					},
				},
			},
			setup = {
				rust_analyzer = function(_, opts)
					local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
					require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
					return true
				end,
			},
		},
	},
}
