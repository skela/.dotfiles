T = {}

T.git_history = function(memory,cmd)
	local g = memory.git
	if g then
		g:toggle()
	else
		local term = require("toggleterm.terminal").Terminal
		local git = term:new({
			cmd = "tig",
			hidden = true,
			count = 2,
			on_open = function(t)
				vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<c-\\>", cmd("2:ToggleTerm"), {noremap = true, silent = true})
			end,
		})
		memory.git = git
		git:toggle()
	end
end

return T
