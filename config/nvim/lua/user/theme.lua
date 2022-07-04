local colorscheme = "gruvbox"

vim.opt.termguicolors = true
vim.opt.guifont = "monospace:h17"



local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

vim.cmd("highlight Normal guibg=none")

