-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.python_recommended_style = 0
vim.o.expandtab = false
vim.shiftwidth = 2
vim.o.tabstop = 2
-- vim.o.smartident = true
vim.o.autoindent = true
-- vim.g.editorconfig = true

vim.g.snacks_animate = false
vim.g.lazyvim_picker = "telescope"

vim.filetype.add({
	extension = {
		conf = "conf",
		env = "dotenv",
		http = "http",
	},
	filename = {
		[".env"] = "dotenv",
		["tsconfig.json"] = "jsonc",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
		["Dockerfile-.*"] = "dockerfile",
		["Slackfile"] = "json",
	},
})

vim.lsp.enable("dartls")

-- vim.opt.guicursor = {
-- 	"n-v-c:block-Cursor/lCursor", -- Block cursor for normal, visual, and command modes
-- 	"i:ver25-Cursor/lCursor", -- Thin vertical line for insert mode
-- }

vim.o.listchars = "tab:!·,trail:·"
vim.o.list = false
vim.o.conceallevel = 2
