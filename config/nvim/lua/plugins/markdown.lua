-- local function find_all(buf, node, pattern)
-- 	local start_row, _, end_row, _ = node:range()
-- 	end_row = end_row + (start_row == end_row and 1 or 0)
-- 	local lines = vim.api.nvim_buf_get_lines(buf, start_row, end_row, false)
-- 	local result = {}
-- 	for row, line in ipairs(lines) do
-- 		---@type integer|nil
-- 		local index = 1
-- 		while index ~= nil do
-- 			local start_index, end_index = line:find(pattern, index)
-- 			if start_index == nil or end_index == nil then
-- 				index = nil
-- 			else
-- 				table.insert(result, {
-- 					row = start_row + row - 1,
-- 					col = { start_index - 1, end_index },
-- 				})
-- 				index = end_index + 1
-- 			end
-- 		end
-- 	end
-- 	return result
-- end
-- local function mark(match, text)
-- 	return {
-- 		conceal = true,
-- 		start_row = match.row,
-- 		start_col = match.col[1],
-- 		opts = {
-- 			end_col = match.col[2],
-- 			conceal = "",
-- 			virt_text = { { text, "DiagnosticOk" } },
-- 			virt_text_pos = "inline",
-- 		},
-- 	}
-- end
-- local function render_dashes(root, buf)
-- 	local query = vim.treesitter.query.parse("markdown_inline", '((inline) @replacements (#lua-match? @replacements "[%.%-][%.%-]"))')
-- 	local result = {}
-- 	for _, node in query:iter_captures(root, buf) do
-- 		local _, start_col, _, _ = node:range()
-- 		if start_col == 0 then
-- 			-- 3 or more dots
-- 			local ellipses = find_all(buf, node, "%.%.%.+")
-- 			for _, ellipse in ipairs(ellipses) do
-- 				table.insert(result, mark(ellipse, "…"))
-- 			end
-- 			-- 2 or more hyphens
-- 			local dashes = find_all(buf, node, "%-%-+")
-- 			for _, dash in ipairs(dashes) do
-- 				local width = dash.col[2] - dash.col[1]
--
-- 				local ems = math.floor(width / 3)
-- 				width = math.fmod(width, 3)
--
-- 				local ens = math.floor(width / 2)
-- 				width = math.fmod(width, 2)
--
-- 				local text = string.rep("—", ems) .. string.rep("–", ens) .. string.rep("-", width)
--
-- 				table.insert(result, mark(dash, text))
-- 			end
-- 		end
-- 	end
-- 	return result
-- end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
			-- custom_handlers = {
			-- 	markdown_inline = { extends = true, parse = render_dashes },
			-- },
			bullet = {
				icons = { "•", "◦", "▪" },
				right_pad = 1,
			},
			checkbox = {
				enabled = true,
				render_modes = false,
				bullet = false,
				left_pad = 0,
				right_pad = 1,
				unchecked = {
					icon = "󰄱 ",
					highlight = "RenderMarkdownUnchecked",
					scope_highlight = nil,
				},
				checked = {
					icon = "󰱒 ",
					highlight = "RenderMarkdownChecked",
					scope_highlight = nil,
				},
				custom = {
					todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
				},
				scope_priority = nil,
			},
		},
		ft = { "markdown", "Avante" },
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		--   "BufReadPre path/to/my-vault/**.md",
		--   "BufNewFile path/to/my-vault/**.md",
		-- },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			ui = { enable = false },
			workspaces = {
				{
					name = "notes",
					path = "~/documents/notes",
				},
			},
		},
	},
	{
		"3rd/diagram.nvim",
		dependencies = {
			{ "3rd/image.nvim", opts = {} }, -- you'd probably want to configure image.nvim manually instead of doing this
		},
		opts = { -- you can just pass {}, defaults below
			events = {
				render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
				clear_buffer = { "BufLeave", "InsertEnter" },
			},
			renderer_options = {
				mermaid = {
					background = "transparent", -- nil | "transparent" | "white" | "#hex"
					theme = "dark", -- nil | "default" | "dark" | "forest" | "neutral"
					scale = 1, -- nil | 1 (default) | 2  | 3 | ...
					width = nil, -- nil | 800 | 400 | ...
					height = nil, -- nil | 600 | 300 | ...
					cli_args = nil, -- nil | { "--no-sandbox" } | { "-p", "/path/to/puppeteer" } | ...
				},
				plantuml = {
					charset = nil,
					cli_args = nil, -- nil | { "-Djava.awt.headless=true" } | ...
				},
				d2 = {
					theme_id = nil,
					dark_theme_id = nil,
					scale = nil,
					layout = nil,
					sketch = nil,
					cli_args = nil, -- nil | { "--pad", "0" } | ...
				},
				gnuplot = {
					size = nil, -- nil | "800,600" | ...
					font = nil, -- nil | "Arial,12" | ...
					theme = "dark", -- nil | "light" | "dark" | custom theme string
					cli_args = nil, -- nil | { "-p" } | { "-c", "config.plt" } | ...
				},
			},
		},
	},
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	ft = { "markdown" },
	-- 	build = function() vim.fn["mkdp#util#install"]() end,
	-- 	init = function() vim.g.mkdp_browser = "firefox-developer-edition" end,
	-- },
}
