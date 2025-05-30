return {
	{
		"williamboman/mason.nvim",
		keys = {},
		opts = {
			ensure_installed = {
				"biome",
				"codelldb",
				"dart-debug-adapter",
				"debugpy",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"gofumpt",
				"goimports",
				"gopls",
				"hadolint",
				"js-debug-adapter",
				"kotlin-debug-adapter",
				"kotlin-language-server",
				"lua-language-server",
				"omnisharp",
				"prettier",
				-- "pyright",
				"rust-analyzer",
				"shellcheck",
				"shfmt",
				"stylua",
				"vtsls",
				"yapf",
				"zls",
				"ols",
				"openscad-lsp",
			},
		},
	},
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		local nls = require("null-ls")
	-- 		opts.sources = opts.sources or {}
	-- 		table.insert(opts.sources, nls.builtins.formatting.prettier, nls.builtins.formatting.yapf)
	-- 	end,
	-- },
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		local nls = require("null-ls")
	-- 		opts.sources = opts.sources or {}
	-- 		table.insert(opts.sources, nls.builtins.formatting.prettier)
	-- 	end,
	-- },
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
		end,
		opts = {
			inlay_hints = { enabled = false },
			servers = {
				-- openscad_lsp = {
				-- 	cmd = { "openscad-lsp", "--stdio" },
				-- 	filetypes = { "openscad" },
				-- 	root_dir = function(fname) return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1]) end,
				-- 	single_file_support = true,
				-- },
				sourcekit = {
					on_attach = function(client, _)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
				},
				ols = {},
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
					-- on_attach = on_attach,
				},
				zls = {},
				pyright = {},
			},
			setup = {
				rust_analyzer = function(_, opts)
					local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
					require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
					return true
				end,
				pyright = function(_, _) require("dap-python").setup() end,
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = { markdown = { "markdownlint" } },
		},
		config = function()
			local markdownlint = require("lint").linters.markdownlint
			markdownlint.args = {
				"--disable",
				"MD013",
				"--", -- Required
			}
		end,
	},
}
