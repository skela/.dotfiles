return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	event = "VeryLazy",
	dependencies = "nvim-lua/plenary.nvim",
	config = function(_, _)
		local harpoon = require("harpoon")
		vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon Append" })
		vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Quick Menu" })
		vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Quick Menu" })
		vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon Select 1" })
		vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon Select 2" })
		vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon Select 3" })
		vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon Select 4" })
		vim.keymap.set("n", "<leader>hn", function() harpoon:list():next({ ui_nav_wrap = true }) end, { desc = "Harpoon Next" })
		vim.keymap.set("n", "<leader>hb", function() harpoon:list():prev({ ui_nav_wrap = true }) end, { desc = "Harpoon Back" })
	end,
}
