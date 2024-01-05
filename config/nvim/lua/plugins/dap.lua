return {
	{
		"mfussenegger/nvim-dap",
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
			vim.keymap.set("n", "<leader>ce", "<cmd>:DapToggleRepl<cr>", { desc = "RePL", remap = true })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
}
