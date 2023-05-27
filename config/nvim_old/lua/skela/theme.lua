local utils = require("skela.utils")

local colorscheme = "darkplus"
vim.opt.termguicolors = true
vim.opt.guifont = "monospace:h17"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

vim.cmd("highlight Normal guibg=none")

local lualine = utils.require_safely("lualine")
if lualine then
	local powerline = require("lualine.themes.powerline_dark")
	powerline.insert.c.bg = "#FF0000"
	lualine.setup {
		options = {
			theme = powerline
		},
		sections = {
			lualine_x = {"encoding","filetype"}
		}
	}
end

--  local colors = utils.require_safely("vscode.colors")
--  if not colors then return end
--  local c = colors.get_colors()

local vscode = utils.require_safely("vscode")
if not vscode then return end

vscode.setup {
	italic_comments = true,
	transparent = false,
}

vscode.load()

