return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"ldelossa/nvim-dap-projects",
			"nvim-treesitter/nvim-treesitter",
			"theHamsta/nvim-dap-virtual-text",
		},
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
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
			vim.keymap.set("n", "<F5>", function() dap.continue() end)
			vim.keymap.set("n", "<F10>", function() dap.step_over({}) end)
			vim.keymap.set("n", "<F11>", function() dap.step_into({}) end)
			vim.keymap.set("n", "<F12>", function() dap.step_out({}) end)
			vim.keymap.set("n", "<leader>cdb", function() dap.toggle_breakpoint() end, { desc = "Breakpoint", remap = true })
			vim.keymap.set(
				"n",
				"<leader>cdB",
				function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
				{ desc = "Set Breakpoint", remap = true }
			)
			vim.keymap.set("n", "<leader>cdl", "<cmd>:Telescope dap list_breakpoints<cr>", { desc = "List Breakpoints", remap = true })
			vim.keymap.set("n", "<leader>cdc", "<cmd>:Telescope dap frames<cr>", { desc = "Callstack", remap = true })
			vim.keymap.set("n", "<leader>cdr", "<cmd>:DapToggleRepl<cr>", { desc = "RePL", remap = true })
			require("nvim-dap-projects").search_project_config()
			require("nvim-dap-virtual-text").setup({})
			dap.defaults.dart.on_output = function(_, _) end
			-- require("dap").set_log_level("TRACE")
			-- local dap = require("dap")
			-- dap.listeners.before["event_progress_start"]["skela"] = function(id, title) print("event progress start", vim.inspect(id), vim.inspect(title)) end
			-- dap.listeners.before["event_progress_update"]["skela"] = function(body)
			-- 	print("event progress update", vim.inspect(body.message), vim.inspect(body.message))
			-- end
			-- dap.listeners.before["event_terminated"]["skela"] = function(session, body) print("Session terminated", vim.inspect(session), vim.inspect(body)) end
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
			vim.keymap.set("n", "<leader>cdi", function() require("dapui").toggle() end, { desc = "Debug UI", remap = true })
			-- local dap = require("dap")
			-- local dapui = require("dapui")
			-- dap.listeners.before.attach.dapui_config = function() print("dapui attach") end
			-- dap.listeners.before.launch.dapui_config = function() print("dapui launch") end
			-- dap.listeners.before.event_terminated.dapui_config = function() print("dapui ev termin") end
			-- dap.listeners.before.event_exited.dapui_config = function() print("dapui ev exit") end
		end,
	},
}
