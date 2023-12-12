local colors = require("../utils/colors")

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			table.insert(opts.sections.lualine_x, {
				function()
					local decorations = vim.g.flutter_tools_decorations or {}
					local project_config = decorations.project_config or {}
					return project_config.name or "hello"
				end,
				-- icon = "version:",
				color = { fg = colors.orange, gui = "bold" },
			})
			opts.sections.lualine_y = { "encoding" }
			opts.sections.lualine_z = { "location", "progress" }
			return opts
		end,
	},
}
