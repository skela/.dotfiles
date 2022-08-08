local colorscheme = "darkplus"

vim.opt.termguicolors = true
vim.opt.guifont = "monospace:h17"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

vim.cmd("highlight Normal guibg=none")

require("lualine").setup {
	options = {
		theme = "powerline_dark"
	},
	sections = {
		lualine_x = {"encoding","filetype"}
	}
}
