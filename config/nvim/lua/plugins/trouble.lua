return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		-- stylua: ignore start
		{"<leader>tt", function() require("trouble").toggle() end, desc = "Trouble" },
		{"<leader>tn", function() require("trouble").next({ skip_groups = true, jump = true }) end, desc = "Trouble (next)" },
		{"<leader>tp", function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = "Trouble (previous)" },
		-- stylua: ignore end
	},
}
