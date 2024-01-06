return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"ldelossa/nvim-dap-projects",
		},
		event = "VeryLazy",
		config = function()
			vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "debugBreakpoint", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", {
				text = "",
				texthl = "debugBreakpoint",
				linehl = "debugPC",
				numhl = "",
			})
			vim.keymap.set("n", "<F5>", function() require("dap").continue() end)
			vim.keymap.set("n", "<F10>", function() require("dap").step_over({}) end)
			vim.keymap.set("n", "<F11>", function() require("dap").step_into({}) end)
			vim.keymap.set("n", "<F12>", function() require("dap").step_out({}) end)
			vim.keymap.set("n", "<leader>cb", function() require("dap").toggle_breakpoint() end, { desc = "Breakpoint", remap = true })
			vim.keymap.set("n", "<leader>cB", "<cmd>:Telescope dap list_breakpoints<cr>", { desc = "List Breakpoints", remap = true })
			vim.keymap.set("n", "<leader>cc", "<cmd>:Telescope dap frames<cr>", { desc = "Callstack", remap = true })
			vim.keymap.set("n", "<leader>ce", "<cmd>:DapToggleRepl<cr>", { desc = "RePL", remap = true })
			require("nvim-dap-projects").search_project_config()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		event = "VeryLazy",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("dapui").setup({
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.5,
							},
							-- {
							-- 	id = "breakpoints",
							-- 	size = 0,
							-- },
							{
								id = "stacks",
								size = 0.5,
							},
							-- {
							-- 	id = "watches",
							-- 	size = 0.4,
							-- },
						},
						position = "left",
						size = 100,
					},
					{
						elements = {
							{
								id = "repl",
								size = 1.0,
							},
							-- {
							-- 	id = "console",
							-- 	size = 0.5,
							-- },
						},
						position = "bottom",
						size = 30,
					},
				},
			})
			vim.keymap.set("n", "<leader>ci", function() require("dapui").toggle() end, { desc = "Debug UI", remap = true })
		end,
	},
}
