return {

	{
		"sidlatau/neotest-dart",
		dependencies = {
			"nvim-neotest/neotest",
		},
		lazy = false,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"sidlatau/neotest-dart",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-dart")({
						command = "flutter",
						use_lsp = true,
					}),
				},
			})
		end,
		keys = {
			{ "<leader>tD", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
		},
	},

	{
		-- "skela/quicktest.nvim",
		-- branch = "feature/dart",
		"quolpr/quicktest.nvim",
		-- dir = "~/code/quicktest.nvim/",
		-- dev = { true },
		config = function()
			local qt = require("quicktest")

			qt.setup({
				adapters = {
					-- require("quicktest.adapters.dart"),
					-- require("quicktest.adapters.golang")({
					-- 	additional_args = function(bufnr) return { "-race", "-count=1" } end,
					-- 	-- bin = function(bufnr) return 'go' end
					-- 	-- cwd = function(bufnr) return 'your-cwd' end
					-- }),
					-- require("quicktest.adapters.vitest"),
					-- require("quicktest.adapters.elixir"),
					-- require("quicktest.adapters.criterion"),
					require("quicktest.adapters.golang"),
					require("quicktest.adapters.dart"),
				},
				default_win_mode = "popup",
				use_builtin_colorizer = true,
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"m00qek/baleia.nvim",
		},
		keys = {
			{
				"<leader>tr",
				function()
					local qt = require("quicktest")
					-- current_win_mode return currently opened panel, split or popup
					qt.run_line()
					-- You can force open split or popup like this:
					-- qt().run_current('split')
					-- qt().run_current('popup')
				end,
				desc = "[T]est [R]un",
			},
			{
				"<leader>tR",
				function()
					local qt = require("quicktest")

					qt.run_file()
				end,
				desc = "[T]est [R]un file",
			},
			{
				"<leader>td",
				function()
					local qt = require("quicktest")

					qt.run_dir()
				end,
				desc = "[T]est Run [D]ir",
			},
			{
				"<leader>ta",
				function()
					local qt = require("quicktest")

					qt.run_all()
				end,
				desc = "[T]est Run [A]ll",
			},
			{
				"<leader>tp",
				function()
					local qt = require("quicktest")

					qt.run_previous()
				end,
				desc = "[T]est Run [P]revious",
			},
			{
				"<leader>tt",
				function()
					local qt = require("quicktest")

					qt.toggle_win("popup")
				end,
				desc = "[T]est [T]oggle popup window",
			},
			{
				"<leader>ts",
				function()
					local qt = require("quicktest")

					qt.toggle_win("split")
				end,
				desc = "[T]est Toggle [S]plit window",
			},
		},
	},
}
