-- local keymaps = function()
-- 	return require("config.keymaps").rust()
-- end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"simrat39/rust-tools.nvim",
			"mfussenegger/nvim-dap-python",
		},
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = { "<leader>cl", false }
			-- keys[#keys + 1] = { "<leader>cl", "<cmd>:Telescope diagnostics<cr>", desc = "[l]ist TODOs and Issues" }
		end,
		opts = {
			servers = {
				pyright = {},
				sourcekit = {},
				kotlin_language_server = {},
				dockerls = {},
				docker_compose_language_service = {},
				rust_analyzer = {
					-- keys = require("config.keymaps").rust(),
					-- keys = keymaps(),
					keys = {
						{ "<leader>cD", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
						-- { "K", cmd("RustHoverActions"), desc = "Hover Actions (Rust)" },
						-- { "<leader>cR", cmd("RustCodeAction"), desc = "Code Action (Rust)" },
					},
					settings = { ["rust-analyzer"] = { diagnostics = { disabled = { "unresolved-proc-macro" }, enable_experimental = true } } },
				},
				lua_ls = {
					settings = { Lua = { diagnostics = { globals = { "vim" } } } },
				},
			},
			setup = {
				rust_analyzer = function(_, opts)
					local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
					require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
					return true
				end,
				pyright = function(_, _) require("dap-python").setup() end,
			},
		},
	},
}
