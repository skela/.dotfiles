-- local keymaps = function()
-- 	return require("config.keymaps").rust()
-- end

return {
	{
		"lewis6991/hover.nvim",
		config = function()
			require("hover").setup({
				init = function()
					require("hover.providers.lsp")
					-- require('hover.providers.gh')
					-- require('hover.providers.gh_user')
					-- require('hover.providers.jira')
					require("hover.providers.dap")
					-- require('hover.providers.fold_preview')
					require("hover.providers.diagnostic")
					-- require('hover.providers.man')
					require("hover.providers.dictionary")
				end,
				preview_opts = {
					border = "single",
				},
				preview_window = false,
				title = true,
				mouse_providers = {
					"LSP",
				},
				mouse_delay = 1000,
			})
			-- vim.keymap.set("n", "<MouseMove>", require("hover").hover_mouse, { desc = "hover.nvim (mouse)" })
			-- vim.o.mousemoveevent = true
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"simrat39/rust-tools.nvim",
			"mfussenegger/nvim-dap-python",
		},
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] = { "<leader>cl", false }
			keys[#keys + 1] = { "K", function() require("utils.ui").show_code_info() end }
			keys[#keys + 1] = { "L", function() require("utils.ui").show_code_options() end }
			-- keys[#keys + 1] = { "<leader>cl", "<cmd>:Telescope diagnostics<cr>", desc = "[l]ist TODOs and Issues" }
		end,
		opts = {
			inlay_hints = { enabled = false },
			servers = {
				pyright = {},
				sourcekit = {
					on_attach = function(client, _)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
				},
				kotlin_language_server = {},
				dockerls = {},
				docker_compose_language_service = {},
				rust_analyzer = {
					-- keys = require("config.keymaps").rust(),
					-- keys = keymaps(),
					keys = {
						{ "<leader>cD", "<cmd>RustDebuggables<cr>", desc = "Run Debuggables (Rust)" },
						-- { "K", cmd("RustHoverActions"), desc = "Hover Actions (Rust)" },
						-- { "<leader>cR", cmd("RustCodeAction"), desc = "Code Action (Rust)" },
					},
					settings = { ["rust-analyzer"] = { diagnostics = { disabled = { "unresolved-proc-macro" }, enable_experimental = true } } },
				},
				lua_ls = {
					settings = { Lua = { diagnostics = { globals = { "vim" } } } },
				},
				-- tailwindcss = {
				-- 	-- exclude a filetype from the default_config
				-- 	filetypes_exclude = { "markdown" },
				-- 	-- add additional filetypes to the default_config
				-- 	filetypes_include = {},
				-- 	-- to fully override the default_config, change the below
				-- 	-- filetypes = {}
				-- 	classRegex = {
				-- 		{ "styles \\=([^;]*);", "'([^']*)'" },
				-- 		{ "styles \\=([^;]*);", '"([^"]*)"' },
				-- 		{ "styles \\=([^;]*);", "\\`([^\\`]*)\\`" },
				-- 		{ "Styles \\=([^;]*);", "'([^']*)'" },
				-- 		{ "Styles \\=([^;]*);", '"([^"]*)"' },
				-- 		{ "Styles \\=([^;]*);", "\\`([^\\`]*)\\`" },
				-- 	},
				-- },
			},
			setup = {
				rust_analyzer = function(_, opts)
					local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
					require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
					return true
				end,
				pyright = function(_, _) require("dap-python").setup() end,
				-- tailwindcss = function(_, opts)
				-- 	local tw = require("lspconfig.server_configurations.tailwindcss")
				-- 	opts.filetypes = opts.filetypes or {}
				--
				-- 	opts.settings = tw.default_config.settings
				--
				-- 	-- vim.list_extend(opts.settings.tailwindCSS, { experimental = { classRegex = opts.classRegex } })
				--
				-- 	opts.settings.tailwindCSS.experimental = { classRegex = opts.classRegex }
				--
				-- 	-- Add default filetypes
				-- 	vim.list_extend(opts.filetypes, tw.default_config.filetypes)
				--
				-- 	-- Remove excluded filetypes
				-- 	--- @param ft string
				-- 	opts.filetypes = vim.tbl_filter(function(ft) return not vim.tbl_contains(opts.filetypes_exclude or {}, ft) end, opts.filetypes)
				--
				-- 	-- Add additional filetypes
				-- 	vim.list_extend(opts.filetypes, opts.filetypes_include or {})
				-- end,
			},
		},
	},
}
