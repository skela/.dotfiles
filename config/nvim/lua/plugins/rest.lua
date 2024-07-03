return {
	{
		"mistweaverco/kulala.nvim",
		ft = "http",
		config = function()
			local kulala = require("kulala")
			kulala.setup({
				default_env = "prod",
				default_view = "body",
			})
			vim.keymap.set("n", "<leader>pr", kulala.run, { desc = "Run HTTP", remap = true })
			vim.keymap.set("n", "<leader>pv", kulala.toggle_view, { desc = "View HTTP", remap = true })
			vim.keymap.set("n", "<leader>pe", kulala.set_selected_env, { desc = "Env HTTP", remap = true })
		end,
	},
}
