return {
	{
		"vim-test/vim-test",
		keys = {
			{ "<leader>tt", ":TestFile<CR>", desc = "Run File" },
			{ "<leader>tT", ":TestSuite<CR>", desc = "Run All Test Files" },
			{ "<leader>tr", ":TestNearest<CR>", desc = "Run Nearest" },
			{ "<leader>tl", ":TestLast<CR>", desc = "Run Last Test" },
			{ "<leader>tv", ":TestVisit<CR>", desc = "Run Previous Visited Test File" },
		},
	},
}
--
-- return {
-- 	{
-- 		"nvim-neotest/neotest",
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			"antoinemadec/FixCursorHold.nvim",
-- 			"Hecatoncheir/neotest-dart",
-- 		},
-- 		opts = {
-- 			adapters = {
-- 				["neotest-rust"] = {},
-- 				["neotest-dart"] = { command = "flutter", use_lsp = true },
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
