-- return {
-- 	{
-- 		"vim-test/vim-test",
-- 		keys = {
-- 			{ "<leader>tt", ":TestFile<CR>", desc = "Run File" },
-- 			{ "<leader>tT", ":TestSuite<CR>", desc = "Run All Test Files" },
-- 			{ "<leader>tr", ":TestNearest<CR>", desc = "Run Nearest" },
-- 			{ "<leader>tl", ":TestLast<CR>", desc = "Run Last Test" },
-- 			{ "<leader>tv", ":TestVisit<CR>", desc = "Run Previous Visited Test File" },
-- 		},
-- 		config = function() vim.g["test#strategy"] = "toggleterm" end,
-- 	},
-- 	{
-- 		"akinsho/nvim-toggleterm.lua",
-- 		config = function()
-- 			require("toggleterm").setup({
-- 				size = 20,
-- 				open_mapping = [[<c-\>]],
-- 				hide_numbers = true,
-- 				shade_filetypes = {},
-- 				shade_terminals = true,
-- 				shading_factor = "1",
-- 				start_in_insert = true,
-- 				insert_mappings = true,
-- 				persist_size = true,
-- 				direction = "float",
-- 				close_on_exit = true,
-- 				shell = vim.o.shell,
-- 				float_opts = {
-- 					border = "curved",
-- 					winblend = 0,
-- 					highlights = {
-- 						border = "Normal",
-- 						background = "Normal",
-- 					},
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
--
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

-- return {
-- 	{
-- 		"nvim-neotest/neotest",
-- 		dependencies = {
-- 			"nvim-neotest/nvim-nio",
-- 			"nvim-lua/plenary.nvim",
-- 			"antoinemadec/FixCursorHold.nvim",
-- 			"Hecatoncheir/neotest-dart",
-- 			"nvim-treesitter/nvim-treesitter",
-- 			"akinsho/flutter-tools.nvim",
-- 		},
-- 		opts = {
-- 			adapters = {
-- 				-- ["neotest-rust"] = {},
-- 				["neotest-dart"] = {
-- 					command = "flutter",
-- 					args = { "test" },
-- 					use_lsp = true,
-- 					dart_sdk_path = "/home/skela/files/sdks/flutter/bin/dart",
-- 					flutter_sdk_path = "/home/skela/files/sdks/flutter",
-- 					custom_test_method_names = {},
-- 				},
-- 				["neotest-python"] = {},
-- 			},
-- 		},
-- 		-- config = function(_, opts)
-- 		-- 	require("neotest").setup(opts)
-- 		--
-- 		-- 	-- vim.keymap.set("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run closest test" })
-- 		-- 	-- vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { desc = "Debug closest test" })
-- 		-- 	-- vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run({ suite = true }) end, { desc = "Run all tests" })
-- 		-- 	-- vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, { desc = "Open test output" })
-- 		-- 	-- vim.keymap.set("n", "<leader>top", function() require("neotest").output_panel.toggle() end, { desc = "Toggle test output panel" })
-- 		-- 	-- vim.keymap.set("n", "<leader>tw", function() require("neotest").watch.toggle() end, { desc = "Toggle test watcher" })
-- 		-- 	-- vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })
-- 		-- end,
-- 		keys = {
-- 			{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
-- 			{ "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
-- 			{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
-- 			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
-- 			{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
-- 			{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
-- 			{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
-- 		},
-- 	},
-- }
