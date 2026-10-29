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
			vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Breakpoint", remap = true })
			vim.keymap.set(
				"n",
				"<leader>dB",
				function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
				{ desc = "Set Breakpoint", remap = true }
			)
			vim.keymap.set("n", "<leader>dl", "<cmd>:Telescope dap list_breakpoints<cr>", { desc = "List Breakpoints", remap = true })
			vim.keymap.set("n", "<leader>dc", "<cmd>:Telescope dap frames<cr>", { desc = "Callstack", remap = true })
			vim.keymap.set("n", "<leader>dr", "<cmd>:DapToggleRepl<cr>", { desc = "RePL", remap = true })
			require("nvim-dap-projects").search_project_config()
			require("nvim-dap-virtual-text").setup({})
			dap.defaults.dart.on_output = function(_, _) end

			-- VSCode Swift launch configs depend on preLaunchTask/target, which nvim-dap can't run
			local launch_json = dap.providers.configs["dap.launch.json"]
			dap.providers.configs["dap.launch.json"] = function(bufnr)
				return vim.tbl_filter(function(c) return c.type ~= "swift" and c.type ~= "lldb" end, launch_json(bufnr))
			end
			-- require("dap").set_log_level("TRACE")
			-- local dap = require("dap")
			-- dap.listeners.before["event_progress_start"]["skela"] = function(id, title) print("event progress start", vim.inspect(id), vim.inspect(title)) end
			-- dap.listeners.before["event_progress_update"]["skela"] = function(body)
			-- 	print("event progress update", vim.inspect(body.message), vim.inspect(body.message))
			-- end
			-- dap.listeners.before["event_terminated"]["skela"] = function(session, body) print("Session terminated", vim.inspect(session), vim.inspect(body)) end

			dap.adapters.lldb = {
				type = "executable",
				command = "/usr/bin/lldb",
				name = "lldb",
			}
			-- swift-bin's lldb-dap links against libpython3.12; borrow uv's copy
			local py312 = vim.fn.glob(vim.fn.expand("~/.local/share/uv/python/cpython-3.12*-linux-x86_64-gnu"), false, true)[1]
			local swift_env = nil
			if py312 then
				local env = vim.fn.environ()
				env.LD_LIBRARY_PATH = py312 .. "/lib"
				env.PYTHONHOME = py312
				swift_env = {}
				for k, v in pairs(env) do
					table.insert(swift_env, k .. "=" .. v)
				end
			end
			dap.adapters.swift = {
				type = "executable",
				command = "/usr/lib/swift/usr/bin/lldb-dap",
				name = "swift",
				options = { env = swift_env },
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
				},
			}
			dap.configurations.swift = {
				{
					name = "Launch",
					type = "swift",
					request = "launch",
					program = function()
						return coroutine.create(function(dap_co)
							local function sh(cmd)
								local co = coroutine.running()
								vim.system(cmd, { text = true }, function(r) vim.schedule(function() coroutine.resume(co, r) end) end)
								return coroutine.yield()
							end
							local function build()
								if vim.fn.filereadable(vim.fn.getcwd() .. "/Package.swift") == 0 then
									local out = "/tmp/" .. vim.fn.expand("%:t:r")
									sh({ "swiftc", "-g", vim.fn.expand("%:p"), "-o", out })
									return out
								end
								local ok, desc = pcall(vim.json.decode, sh({ "swift", "package", "describe", "--type", "json" }).stdout)
								local products = {}
								for _, p in ipairs(ok and desc.products or {}) do
									if p.type.executable then table.insert(products, p.name) end
								end
								local product = products[1]
								if #products > 1 then
									product = products[vim.fn.inputlist(vim.list_extend({ "Product:" }, products))] or product
								end
								if not product then return dap.ABORT end
								vim.notify("Building " .. product .. "…")
								local r = sh({ "swift", "build", "--product", product })
								if r.code ~= 0 then
									vim.notify(r.stdout .. r.stderr, vim.log.levels.ERROR)
									return dap.ABORT
								end
								return vim.trim(sh({ "swift", "build", "--show-bin-path" }).stdout) .. "/" .. product
							end
							coroutine.resume(dap_co, build())
						end)
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
			dap.configurations.c = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						local has_makefile = vim.fn.filereadable(vim.fn.getcwd() .. "/Makefile") == 1
						if has_makefile then
							vim.fn.system("make")
							return vim.fn.input("Binary path: ", vim.fn.getcwd() .. "/", "file")
						else
							local file = vim.fn.expand("%:p")
							local out = "/tmp/" .. vim.fn.expand("%:t:r")
							vim.fn.system("gcc -g " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(out))
							return out
						end
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
			dap.configurations.zig = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						vim.fn.system("zig build")
						return "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}"
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
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
			vim.keymap.set("n", "<leader>di", function() require("dapui").toggle() end, { desc = "Debug UI", remap = true })
			vim.keymap.set("n", "<F9>", function() require("dapui").toggle() end, { desc = "Debug UI", remap = true })
			-- local dap = require("dap")
			-- local dapui = require("dapui")
			-- dap.listeners.before.attach.dapui_config = function() print("dapui attach") end
			-- dap.listeners.before.launch.dapui_config = function() print("dapui launch") end
			-- dap.listeners.before.event_terminated.dapui_config = function() print("dapui ev termin") end
			-- dap.listeners.before.event_exited.dapui_config = function() print("dapui ev exit") end
		end,
	},
}
