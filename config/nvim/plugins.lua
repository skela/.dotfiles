
local options = require "custom.configs.opts"

local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = options.treesitter,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require "plugins.configs.lspconfig"
			require "custom.configs.lspconfig"
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = options.mason,
	},
	{
		"nvim-telescope/telescope.nvim",
		opts = options.telescope,
	},
	{
		"akinsho/toggleterm.nvim",
		opts = options.toggleterm,
		lazy = false,
	},
	-- {
	-- 	"akinsho/flutter-tools.nvim",
	-- 	lazy = false,
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"stevearc/dressing.nvim", -- optional for vim.ui.select
	-- 	},
	-- 	config = true,
	-- },
	{ "mfussenegger/nvim-dap" },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "stevearc/dressing.nvim" },
    config = function()
      require('flutter-tools').setup {
				decorations = {
					statusline = {
						-- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
						-- this will show the current version of the flutter app from the pubspec.yaml file
						app_version = true,
						-- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
						-- this will show the currently running device if an application was started with a specific
						-- device
						device = true,
						-- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
						-- this will show the currently selected project configuration
						project_config = true,
					}
				},
				debugger = {
          -- make these two params true to enable debug mode
          enabled = false,
          run_via_dap = false,
          register_configurations = function(_)

             require("dap").adapters.dart = {
                type = "executable",
                command = vim.fn.stdpath("data") .. "/mason/bin/dart-debug-adapter",
                args = {"flutter"}
              }

            require("dap").configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch flutter",
                dartSdkPath = '/home/skela/files/sdks/flutter/bin/cache/dart-sdk/',
                flutterSdkPath = "/home/skela/files/sdks/flutter",
                program = "${workspaceFolder}/example/lib/main.dart",
                cwd = "${workspaceFolder}",
              }
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
          on_attach = require("lvim.lsp").common_on_attach,
          capabilities = require("lvim.lsp").default_capabilities,
        },
      }
    end
  },
  { -- for dart syntax hightling
    "dart-lang/dart-vim-plugin"
  },
}
return plugins
