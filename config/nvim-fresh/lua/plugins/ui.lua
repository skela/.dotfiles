local neovim_header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]
local easee_header = [[
███████╗ █████╗  ██████╗███████╗███████╗
██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝
█████╗  ███████║╚█████╗ █████╗  █████╗
██╔══╝  ██╔══██║ ╚═══██╗██╔══╝  ██╔══╝
███████╗██║  ██║██████╔╝███████╗███████╗
╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝]]
local aurora_header = [[
 █████╗ ██╗   ██╗██████╗  ██████╗ ██████╗  █████╗
██╔══██╗██║   ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗
███████║██║   ██║██████╔╝██║   ██║██████╔╝███████║
██╔══██║██║   ██║██╔══██╗██║   ██║██╔══██╗██╔══██║
██║  ██║╚██████╔╝██║  ██║╚██████╔╝██║  ██║██║  ██║
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
]]
local rain_header = [[
██████╗ █████╗  ██╗███╗   ██╗
██╔══██╗██╔══██╗██║████╗  ██║
██████╔╝███████║██║██╔██╗ ██║
██╔══██╗██╔══██║██║██║╚██╗██║
██║  ██║██║  ██║██║██║ ╚████║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
]]
require("utils.env").get_hostname()
local header = neovim_header
local hostname = require("utils.env").get_hostname()
if hostname == "dark" then header = easee_header end
if hostname == "arc" then header = easee_header end
if hostname == "aurora" then header = aurora_header end
if hostname == "rain" then header = rain_header end

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
	},
		{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {

			dashboard = {

				preset = {
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},

					header = header,
				},

				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					-- { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					-- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = vim.fn.isdirectory(".git") == 1,
						cmd = "hub status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					},
					-- {
					-- 	section = "terminal",
					-- 	cmd = "pokemon-colorscripts -r --no-title; sleep .1",
					-- 	random = 10,
					-- 	pane = 2,
					-- 	indent = 4,
					-- 	height = 30,
					-- },
					{ section = "startup" },
				},
			},
			picker = {
				-- layout = { preset = "default" }
				sources = {
					lines = {
						layout = "default"
					}
				},
			},
			styles = {
				notification_history = {
					width = 0.9,
					height = 0.9,
				},
			},
		},
		keys = {
			{"<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
			{"<C-p>", function() Snacks.picker.files() end, desc = "Find Files" },
			{"<C-F>", function() Snacks.picker.lines() end, desc = "Search current file" },
			{"\a", function() Snacks.picker.grep() end, desc = "Search all files" }, -- ctrl + shift + f work around for ghostty/kitty
			{"<leader>nn", function() Snacks.notifier.show_history() end, desc = "Open recent [n]otifications"},
			{"<leader>cd", function() Snacks.picker.diagnostics() end, desc = "List [d]iagnostics" },
			{ "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
			{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		  { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
			{ "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
			--map_common("<C-t>", cmd("Snacks filetypes"), { desc = "Select filetype", remap = true })
		}
	},
	{
		"folke/trouble.nvim",
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function(_, opts)
			local icons = require("utils.icons")
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				hl_group = "lualine_c_normal",
			})
		--	opts.sections.lualine_c = {
			--	LazyVim.lualine.root_dir(),
			--	{
			--		"diagnostics",
			--		sources = { "nvim_workspace_diagnostic" },
			--		symbols = {
			--			error = icons.diagnostics.Error,
			--			warn = icons.diagnostics.Warn,
			--			info = icons.diagnostics.Info,
			--			hint = icons.diagnostics.Hint,
			--		},
			--	},
			--	{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
			--	{ LazyVim.lualine.pretty_path() },
			--	{
			--		symbols.get,
			--		cond = symbols.has,
			--	},
		--	}
--			opts.sections.lualine_y = { "encoding" }
	--		opts.sections.lualine_z = { "location", "progress" }
			-- opts.options.theme = "tokyonight"
			-- vim.api.nvim_set_hl(0, "StatusLine", { link = "lualine_c_normal" })
			return opts
		end,
	},
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				offsets = {
					{
						filetype = "neo-tree",
						text = "",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		},
	},
}
