--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
	-- group = config_autocmds,
	pattern = "*",
	callback = function(events)
		local ft = vim.api.nvim_buf_get_option(events.buf, "filetype")
		if ft == "TelescopePrompt" then require("utils.ui").save_picker_state(events.buf) end
	end,
})

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = { "*.c", "*h" },
--   group = vim.api.nvim_create_augroup("custom-indent", { clear = true }),
--   -- callback = function(ev)
--   --   print(string.format("event fired: %s", vim.inspect(ev)))
--   -- end,
--   command = "set cindent shiftwidth=4",
-- })
