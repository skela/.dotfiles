return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"shfmt",
				"pyright",
				"debugpy",
				"rust-analyzer",
				"dart-debug-adapter",
				"kotlin-debug-adapter",
				-- "table",
				"codelldb",
				-- "sourcekit",
				"prettier",
				"hadolint",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				["javascript"] = { "prettier" },
				["javascriptreact"] = { "prettier" },
				["typescript"] = { "prettier" },
				["typescriptreact"] = { "prettier" },
				["vue"] = { "prettier" },
				["css"] = { "prettier" },
				["scss"] = { "prettier" },
				["less"] = { "prettier" },
				["html"] = { "prettier" },
				["json"] = { "prettier" },
				["jsonc"] = { "prettier" },
				["yaml"] = { "prettier" },
				["markdown"] = { "prettier" },
				["markdown.mdx"] = { "prettier" },
				["graphql"] = { "prettier" },
				["handlebars"] = { "prettier" },
				["dart"] = { "blink" },
			},
			formatters = {
				blink = {
					command = "/home/skela/code/blink/target/release/blink",
					args = { "$FILENAME" },
					stdin = false,
					cwd = require("conform.util").root_file({ ".editorconfig", "pubspec.yaml" }),
				},
			},
		},
	},
	{
		"Wansmer/treesj",
		keys = { "<space>m" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function() require("treesj").setup({}) end,
	},
	-- {
	-- 	"nvimtools/none-ls.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		local nls = require("null-ls")
	-- 		opts.sources = opts.sources or {}
	-- 		table.insert(opts.sources, nls.builtins.formatting.prettier)
	-- 	end,
	-- },
}
