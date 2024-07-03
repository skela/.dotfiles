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
				"pyright",
				"rust-analyzer",
				"shellcheck",
				"shfmt",
				"stylua",
				"tailwindcss-language-server",
				"typescript-language-server",
				"vtsls",
				"yapf",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				["javascript"] = { "biome" },
				["javascriptreact"] = { "biome" },
				["typescript"] = { "biome" },
				["typescriptreact"] = { "biome" },
				["vue"] = { "biome" },
				["css"] = { "biome" },
				["scss"] = { "biome" },
				["less"] = { "prettier" },
				["html"] = { "biome" },
				["json"] = { "prettier" },
				["jsonc"] = { "prettier" },
				["yaml"] = { "prettier" },
				["markdown"] = { "prettier" },
				["markdown.mdx"] = { "prettier" },
				["graphql"] = { "prettier" },
				["handlebars"] = { "prettier" },
				["dart"] = { "blink" },
				["python"] = { "yapf" },
				-- ["swift"] = { "swift_format_ext" },
			},
			pattern = {
				[".env.*"] = "dotenv",
			},
			formatters = {
				blink = {
					command = "/home/skela/code/blink/target/release/blink",
					args = { "$FILENAME" },
					stdin = false,
					cwd = require("conform.util").root_file({ ".editorconfig", "pubspec.yaml" }),
				},
				swift_format_ext = {
					command = "swiftformat",
					args = { "$FILENAME" },
					range_args = function(self, ctx)
						return {
							"--linerange",
							ctx.range.start[1] .. "," .. ctx.range["end"][1],
						}
					end,
					stdin = false,
					condition = function(self, ctx) return vim.fs.basename(ctx.filename) ~= "README.md" end,
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
}
