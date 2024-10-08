local M = {}

local state = require("telescope.state")
local last_response = nil

---@diagnostic disable-next-line: unused-local
M.save_picker_state = function(prompt_bufnr)
	local picker = state.get_global_key("ui_picker")
	if picker ~= nil then
		local data = {
			filter_text = "",
			picker_state = {},
		}
		data.picker_state = { selected_item = vim.fn.getpos(".") }
		local action_state = require("telescope.actions.state")
		local text = action_state.get_current_line()
		data.filter_text = text
		state.set_global_key("ui_data." .. picker, data)
		state.set_global_key("ui_picker", nil)
	end
end

M.load_picker_state = function(picker) return state.get_global_key("ui_data." .. picker) end

M.load_picker_state_prompt = function(picker)
	local restored_filter_text = ""
	local data = M.load_picker_state(picker)
	if data ~= nil then restored_filter_text = data.filter_text end
	return restored_filter_text
end

M.open_picker = function(picker)
	state.set_global_key("ui_picker", picker)
	return M.load_picker_state_prompt(picker)
end

M.close_picker = function(prompt_bufnr)
	M.save_picker_state(prompt_bufnr)
	require("telescope.actions").close(prompt_bufnr)
end

M.open_diagnostics = function()
	-- local prompt = M.open_picker("diagnostics")
	require("telescope.builtin").diagnostics({
		-- default_text = prompt,
	})
end

M.search_all_files = function()
	-- local prompt = M.open_picker("live_grep")
	require("telescope.builtin").live_grep({
		-- default_text = prompt,
	})
end

M.search_current_file = function()
	-- local prompt = M.open_picker("current_buffer_fuzzy_find")
	require("telescope.builtin").current_buffer_fuzzy_find({
		-- default_text = prompt,
	})
end

M.show_code_info = function()
	-- vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
	-- vim.lsp.buf.hover()
	require("hover").hover({ providers = { "LSP" } })
end

M.show_code_options = function()
	-- vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
	-- vim.lsp.buf.hover()
	require("hover").hover({})
end

M.set_last_response = function(res) last_response = res end

M.create_floating_window = function(content)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_buf_set_option(buf, "filetype", "json")
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bd!<CR>", { noremap = true, silent = true })
end

M.pretty_print_json = function(value) return vim.fn.system("jq '.'", vim.fn.json_encode(value)) end

M.open_last_request = function()
	if last_response then
		M.create_floating_window(last_response)
	else
		print("No request response available yet.")
	end
end

return M
