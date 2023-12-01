T = {}

local function safe_count(t)
	local count = t.count
	if count then return count end
	return 1
end

T.on_term_open = function(t)
	local count = safe_count(t)
	if count == 1 then T.term1 = t end
	T.current_term = t
	vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<c-\\>", string.format("<cmd>%d:ToggleTerm<cr>",count), {noremap = true, silent = true})
	-- vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-Left>", string.format("<cmd>%d:ToggleTerm<cr>",prev_term(count)), {noremap = true, silent = true})
	-- vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-Right>", string.format("<cmd>%d:ToggleTerm<cr>",next_term(count)), {noremap = true, silent = true})
	vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-Left>", "<cmd>:OpenPreviousTerm<cr>", {noremap = true, silent = true})
	vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-Right>", "<cmd>:OpenNextTerm<cr>", {noremap = true, silent = true})
	--
	-- vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-1>", "<cmd>1:ToggleTerm<cr>", {noremap = true, silent = true})
	-- vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-2>", "<cmd>2:ToggleTerm<cr>", {noremap = true, silent = true})
	-- vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-3>", "<cmd>3:ToggleTerm<cr>", {noremap = true, silent = true})
end

T.on_term_close = function(_)
	-- vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-Left>", "", {noremap = true, silent = true})
	-- vim.api.nvim_buf_set_keymap(t.bufnr, "t", "<A-Right>", "", {noremap = true, silent = true})
end

T.get_or_create_term1 = function()
	local g = T.term1
	if g then
		return g
	else
		local term = require("toggleterm.terminal").Terminal
		local t1 = term:new({
			hidden = true,
			count = 1,
			on_open = T.on_term_open,
			on_close = T.on_term_close,
		})
		T.term1 = t1
		return t1
	end
end

T.get_or_create_term2 = function()
	local g = T.term2
	if g then
		return g
	else
		local term = require("toggleterm.terminal").Terminal
		local t2 = term:new({
			hidden = true,
			count = 2,
			on_open = T.on_term_open,
			on_close = T.on_term_close,
		})
		T.term2 = t2
		return t2
	end
end

T.get_or_create_term3 = function()
	local g = T.term3
	if g then
		return g
	else
		local term = require("toggleterm.terminal").Terminal
		local t3 = term:new({
			cmd = "tig",
			hidden = true,
			count = 3,
			on_open = T.on_term_open,
			on_close = T.on_term_close,
		})
		T.term3 = t3
		return t3
	end
end

T.get_or_create_term = function(count)
	if count == 1 then return T.get_or_create_term1() end
	if count == 2 then return T.get_or_create_term2() end
	if count == 3 then return T.get_or_create_term3() end
	return nil
end

T.toggle2 = function()
	local t = T.get_or_create_term2()
	t:toggle(2)
end

T.toggle3 = function()
	local t = T.get_or_create_term3()
	t:toggle(3)
end

T.open_term = function(count)
	local old = T.current_term
	if old then old:toggle(old.count) end
	local t = T.get_or_create_term(count)
	if t then
		t:toggle(t.count)
	end
end

T.open_term1 = function() T.open_term(1) end
T.open_term2 = function() T.open_term(2) end
T.open_term3 = function() T.open_term(3) end

T.open_next_term = function()
	local count = 1
	local old = T.current_term
	if old then
		count = safe_count(old)
		old:toggle(count)
	end
	count = count + 1
	if count > 3 then
		count = 1
	end
	local t = T.get_or_create_term(count)
	t:toggle()
	T.current_term = t
end

T.open_previous_term = function()
	local count = 1
	local old = T.current_term
	if old then
		count = safe_count(old)
		old:toggle(count)
	end
	count = count - 1
	if count < 1 then
		count = 3
	end
	local t = T.get_or_create_term(count)
	t:toggle()
	T.current_term = t
end

-- vim.api.nvim_create_user_command("OpenTerm1", function() T.open_term1() end,{})
-- vim.api.nvim_create_user_command("OpenTerm2", function() T.open_term2() end,{})
-- vim.api.nvim_create_user_command("OpenTerm3", function() T.open_term3() end,{})
vim.api.nvim_create_user_command("OpenNextTerm", function() T.open_next_term() end,{})
vim.api.nvim_create_user_command("OpenPreviousTerm", function() T.open_previous_term() end,{})

return T
