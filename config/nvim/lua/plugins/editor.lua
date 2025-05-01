return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "VeryLazy",
		dependencies = "nvim-lua/plenary.nvim",
		config = function(_, _)
			local harpoon = require("harpoon")
			vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon Append" })
			vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Quick Menu" })
			vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Quick Menu" })
			vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon Select 1" })
			vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon Select 2" })
			vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon Select 3" })
			vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon Select 4" })
			vim.keymap.set("n", "<leader>hn", function() harpoon:list():next({ ui_nav_wrap = true }) end, { desc = "Harpoon Next" })
			vim.keymap.set("n", "<leader>hb", function() harpoon:list():prev({ ui_nav_wrap = true }) end, { desc = "Harpoon Back" })
		end,
	},
	{
		"telescope.nvim",
		dependencies = {
			"nvim-telescope/telescope-fzf-native.nvim",
			"nvim-telescope/telescope-dap.nvim",
			-- "nvim-telescope/telescope-media-files.nvim",
			build = "make",
			config = function()
				require("telescope").load_extension("fzf")
				require("telescope").load_extension("dap")
				require("telescope").load_extension("rest")
				-- require("telescope").load_extension("media_files")
			end,
		},
		opts = {
			defaults = {
				-- wrap_results = true,
				-- sorting_strategy = "ascending",
				layout_config = {
					width = 0.98,
				},
				layout_strategy = "vertical",
				file_ignore_patterns = {
					"^.git/",
					"^node_modules/",
				},
				mappings = {
					i = {
						["<C-p>"] = require("telescope.actions.layout").toggle_preview,
						["<esc>"] = require("utils.ui").close_picker,
					},
				},
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
					layout_strategy = "vertical",
				},
				live_grep = {
					only_sort_text = true,
					layout_strategy = "vertical",
				},
				diagnostics = {
					line_width = "full",
					layout_strategy = "vertical",
				},
				lsp_references = {
					layout_strategy = "vertical",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"bash",
				"fish",
				"html",
				"javascript",
				"json",
				"hjson",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
				"dart",
				"swift",
				"rust",
				"css",
				"kotlin",
				"dockerfile",
				"http",
				"xml",
				"graphql",
				-- "pkl",
				"http",
				"zig",
				-- "openscad",
			},
			indent = {
				enable = true,
				disable = { "dart", "swift", "rust" },
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.treesitter.language.register("bash", "dotenv")
		end,
		build = ":TSUpdate",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			event_handlers = {
				{
					event = "file_opened",
					handler = function() require("neo-tree.command").execute({ action = "close" }) end,
				},
			},
			source_selector = {
				winbar = false,
				statusline = false,
			},
		},
	},
	{
		"akinsho/nvim-toggleterm.lua",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = "1",
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						border = "Normal",
						background = "Normal",
					},
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>t", group = "+test", icon = { icon = "󰙨" } },
				{ "<leader>r", group = "+run", icon = { icon = "" } },
				{ "<leader>h", group = "+harpoon", icon = { icon = "󰛢" } },
				{ "<leader>co", group = "+open", icon = { icon = "" } },
				{ "<leader>cV", group = "+viewdroid", icon = { icon = "" } },
				{ "<leader>n", group = "+neovim", icon = { icon = "" } },
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
		init = function() vim.g.mkdp_browser = "firefox-developer-edition" end,
	},
}
