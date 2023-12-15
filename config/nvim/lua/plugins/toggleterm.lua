return {
	"akinsho/toggleterm.nvim",
	event = "VeryLazy",
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "float",
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = "curved",
			},
		})

		local float_handler = function(term)
			if vim.fn.mapcheck("jk", "t") ~= "" then
				vim.api.nvim_buf_del_keymap(term.bufnr, "t", "jk")
				vim.api.nvim_buf_del_keymap(term.bufnr, "t", "<esc>")
			end
		end

		local Terminal = require("toggleterm.terminal").Terminal

		local lazygit = Terminal:new({
			cmd = "lazygit",
			dir = "git_dir",
			hidden = true,
			direction = "float",
			on_open = float_handler,
		})

		local tig = Terminal:new({
			cmd = "tig",
			dir = "git_dir",
			hidden = true,
			direction = "float",
			on_open = float_handler,
		})

		local htop = Terminal:new({
			cmd = "htop",
			hidden = true,
			direction = "float",
			on_open = float_handler,
		})

		vim.api.nvim_create_user_command("Htop", function()
			htop:toggle()
		end, {})

		vim.api.nvim_create_user_command("Lazygit", function()
			lazygit:toggle()
		end, {})

		vim.api.nvim_create_user_command("Tig", function()
			tig:toggle()
		end, {})

		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		function _TIG_TOGGLE()
			tig:toggle()
		end

		function _HTOP_TOGGLE()
			htop:toggle()
		end
	end,
	keys = {
		{ "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Terminal lazygit" },
		{ "<leader>th", "<cmd>lua _HTOP_TOGGLE()<CR>", desc = "Terminal htop" },
		{ "<leader>tt", "<cmd>lua _TIG_TOGGLE()<CR>", desc = "Terminal tig" },
	},
}
