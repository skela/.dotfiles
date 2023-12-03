return {
	{ "mfussenegger/nvim-dap" },
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- "stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup({
				decorations = {
					statusline = {
						app_version = true,
						device = true,
						project_config = true,
					},
				},
				debugger = {
					-- make these two params true to enable debug mode
					enabled = false,
					run_via_dap = false,
					register_configurations = function(_)
						require("dap").adapters.dart = {
							type = "executable",
							command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
							args = { "flutter" },
						}

						require("dap").configurations.dart = {
							{
								type = "dart",
								request = "launch",
								name = "Launch flutter",
								dartSdkPath = "/home/skela/files/sdks/flutter/bin/cache/dart-sdk/",
								flutterSdkPath = "/home/skela/files/sdks/flutter",
								program = "${workspaceFolder}/example/lib/main.dart",
								cwd = "${workspaceFolder}",
							},
						}
						-- uncomment below line if you've launch.json file already in your vscode setup
						require("dap.ext.vscode").load_launchjs()
					end,
				},
				dev_log = {
					-- toggle it when you run without DAP
					enabled = false,
					open_cmd = "tabedit",
				},

				lsp = {
					-- on_attach = function()
					-- 	-- require("config.keymaps")
					-- 	vim.keymap.set({ "n", "i", "x", "s" }, "<C-`>", "<cmd>TroubleToggle<cr>", { desc = "Show/Hide Problems", remap = true })
					-- end,
					settings = {
						showTodos = true,
						enableSdkFormatter = false,
					},
				},
			})
		end,
	},
	{ -- for dart syntax hightling
		"dart-lang/dart-vim-plugin",
	},
}
