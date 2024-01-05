local my_on_attach = function(client, buffer) require("config.keymaps").flutter(client, buffer) end

return {
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
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
					enabled = true,
					run_via_dap = true,
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
							},
						}
						require("dap.ext.vscode").load_launchjs()
					end,
				},
				outline = {
					open_cmd = "60vnew",
					auto_open = false,
				},
				dev_log = {
					enabled = false,
					open_cmd = "",
					-- open_cmd = "tabedit",
					-- open_cmd = "30vnew",
					-- open_cmd = "30new",
				},
				lsp = {
					on_attach = my_on_attach,
					settings = {
						showTodos = true,
						enableSdkFormatter = false,
					},
					color = {
						enabled = true,
						background = false,
						background_color = { r = 0, g = 0, b = 0 },
						foreground = false,
						virtual_text = true,
						virtual_text_str = "■",
					},
				},
			})
		end,
	},
	{ -- for dart syntax highlighting
		"dart-lang/dart-vim-plugin",
	},
}
