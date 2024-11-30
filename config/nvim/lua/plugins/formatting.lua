return {
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
			-- ["yaml"] = { "prettier" },
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
				range_args = function(_, ctx)
					return {
						"--linerange",
						ctx.range.start[1] .. "," .. ctx.range["end"][1],
					}
				end,
				stdin = false,
				condition = function(_, ctx) return vim.fs.basename(ctx.filename) ~= "README.md" end,
			},
		},
	},
	{
		"Wansmer/treesj",
		keys = { "<space>m" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({
				max_join_length = 500,
			})
		end,
	},
}
