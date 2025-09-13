return {
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
			local flutter = require("flutter-tools")
			flutter.setup({
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
					-- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
					-- see |:help dap.set_exception_breakpoints()| for more info
					exception_breakpoints = {},
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
							},
						}
						-- require("dap.ext.vscode").load_launchjs((vim.fn.getcwd() .. "/.nvim/dap.json"))
						require("dap.ext.vscode").load_launchjs()
						local dap = require("dap")
						if require("utils.tables").length(dap.configurations["dart"]) > 1 then table.remove(dap.configurations["dart"], 1) end

						vim.keymap.set("n", "<F5>", function()
							local commands = require("flutter-tools.commands")
							if commands.is_running() then
								vim.cmd("DapContinue")
							else
								vim.cmd("FlutterRun")
							end
						end)
					end,
				},
				outline = {
					open_cmd = "60vnew",
					auto_open = false,
				},
				closing_tags = {
					highlight = "ErrorMsg", -- highlight for the closing tag
					prefix = ">", -- character to use for close tag e.g. > Widget
					priority = 10, -- priority of virtual text in current line
					-- consider to configure this when there is a possibility of multiple virtual text items in one line
					-- see `priority` option in |:help nvim_buf_set_extmark| for more info
					enabled = true, -- set to false to disable
				},
				dev_log = {
					enabled = false,
					-- notify_errors = false,
					-- open_cmd = "tabedit",
					open_cmd = "60vnew",
					-- open_cmd = "30new",
				},
				lsp = {
					on_attach = function(client, buffer)
						-- require("user.lsp.handlers").on_attach(client, buffer)
						require("config.keymaps").flutter(client, buffer)
					end,
					-- capabilities = require("user.lsp.handlers").capabilities,
					settings = {
						showTodos = false,
						completeFunctionCalls = true,
						enableSdkFormatter = false,
						analysisExcludedFolders = {
							".dart_tool",
							"/home/skela/files/sdks/flutter",
							"/home/skela/files/sdks/flutter/packages",
							"/home/skela/.pub-cache",
							"/home/skela/.puro",
							"/home/skela/files/sdks/fvm",
						},
						enableSnippets = true,
						updateImportsOnRename = true,
					},
					color = {
						enabled = true,
						background = false,
						-- background_color = { r = 0, g = 0, b = 0 },
						background_color = nil,
						foreground = false,
						virtual_text = true,
						virtual_text_str = "⏺",
					},
				},
			})
		end,
	},
	{ -- for dart syntax highlighting
		"dart-lang/dart-vim-plugin",
	},
	{ "luckasRanarison/tree-sitter-hyprlang", dependencies = { "nvim-treesitter/nvim-treesitter" } },
}
