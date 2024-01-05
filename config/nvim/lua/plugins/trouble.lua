return {
	-- {
	-- 	"folke/todo-comments.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	opts = {
	-- 		keywords = {
	-- 			FIX = {
	-- 				icon = " ", -- icon used for the sign, and in search results
	-- 				color = "error", -- can be a hex color, or a named color (see below)
	-- 				alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
	-- 				-- signs = false, -- configure signs for some keywords individually
	-- 			},
	-- 			TODO = { icon = " ", color = "todo", alt = { "todo" } },
	-- 			HACK = { icon = " ", color = "warning" },
	-- 			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
	-- 			PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
	-- 			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
	-- 			TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
	-- 		},
	-- 		colors = {
	-- 			error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
	-- 			warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
	-- 			info = { "DiagnosticInfo", "#2563EB" },
	-- 			hint = { "DiagnosticHint", "#10B981" },
	-- 			default = { "Identifier", "#7C3AED" },
	-- 			test = { "Identifier", "#FF00FF" },
	-- 			todo = { "dart (todo)", "#2563EB" },
	-- 		},
	-- 	},
	-- },
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
		opts = {
			multiline = true,
			signs = {
				error = "",
				warning = "",
				hint = "",
				information = "",
				other = "",
				todo = "",
			},
			use_diagnostic_signs = true,
		},
		keys = {
			{ "<leader>tt", function() require("trouble").toggle("workspace_diagnostics") end, desc = "Trouble" },
			{ "<leader>tn", function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "Trouble (next)" },
			{ "<leader>tp", function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = "Trouble (previous)" },
		},
	},
}
