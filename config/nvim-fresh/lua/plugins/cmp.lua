return {
	{
  "saghen/blink.cmp",
  version = not vim.g.lazyvim_blink_main and "*",
  build = vim.g.lazyvim_blink_main and "cargo build --release",
  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },
  dependencies = {
    "rafamadriz/friendly-snippets",
    -- add blink.compat to dependencies
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
  },
  event = { "InsertEnter", "CmdlineEnter" },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    snippets = {
      preset = "default",
    },

    appearance = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = false,
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    completion = {
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = false,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = vim.g.ai_cmp,
      },
    },

    -- experimental signature help support
    -- signature = { enabled = true },

    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      compat = {},
      default = { "lsp", "path", "snippets", "buffer" },
    },

    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        ["<Right>"] = false,
        ["<Left>"] = false,
      },
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ":"
          end,
        },
        ghost_text = { enabled = true },
      },
    },

    keymap = {
      preset = "enter",
      ["<C-y>"] = { "select_and_accept" },
    },
  },
  ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
  config = function(_, opts)
    if opts.snippets and opts.snippets.preset == "default" then
      opts.snippets.expand = LazyVim.cmp.expand
    end
    -- setup compat sources
    local enabled = opts.sources.default
    for _, source in ipairs(opts.sources.compat or {}) do
      opts.sources.providers[source] = vim.tbl_deep_extend(
        "force",
        { name = source, module = "blink.compat.source" },
        opts.sources.providers[source] or {}
      )
      if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
        table.insert(enabled, source)
      end
    end

    -- add ai_accept to <Tab> key
    if not opts.keymap["<Tab>"] then
      if opts.keymap.preset == "super-tab" then -- super-tab
        opts.keymap["<Tab>"] = {
          require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
          LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
          "fallback",
        }
      else -- other presets
        opts.keymap["<Tab>"] = {
          LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
          "fallback",
        }
      end
    end

    -- Unset custom prop to pass blink.cmp validation
    opts.sources.compat = nil

    -- check if we need to override symbol kinds
    for _, provider in pairs(opts.sources.providers or {}) do
      ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
      if provider.kind then
        local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
        local kind_idx = #CompletionItemKind + 1

        CompletionItemKind[kind_idx] = provider.kind
        ---@diagnostic disable-next-line: no-unknown
        CompletionItemKind[provider.kind] = kind_idx

        ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
        local transform_items = provider.transform_items
        ---@param ctx blink.cmp.Context
        ---@param items blink.cmp.CompletionItem[]
        provider.transform_items = function(ctx, items)
          items = transform_items and transform_items(ctx, items) or items
          for _, item in ipairs(items) do
            item.kind = kind_idx or item.kind
            item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
          end
          return items
        end

        -- Unset custom prop to pass blink.cmp validation
        provider.kind = nil
      end
    end

    require("blink.cmp").setup(opts)
  end,
},
	-- {
	-- 	"saghen/blink.cmp",
	-- 	dependencies = "rafamadriz/friendly-snippets",
	-- 	opts = function(_, opts)
	-- 		opts.completion.accept.auto_brackets.enabled = false
	-- 		opts.completion.list = { selection = { preselect = false, auto_insert = false } }
	-- 		opts.signature = { enabled = true }
	-- 	end,
	-- },
	-- {
	-- 	-- https://github.com/saghen/blink.cmp?tab=readme-ov-file#configuration
	-- 	"saghen/blink.cmp",
	-- 	version = "v0.7.6",
	-- 	dependencies = "rafamadriz/friendly-snippets",
	-- 	-- event = "InsertEnter",
	-- 	opts = {
	-- 		keymap = {
	-- 			preset = "default",
	-- 			-- ["<Right>"] = { "select_and_accept", "fallback" },
	-- 			["<Right>"] = { "accept", "fallback" },
	--
	-- 			-- preset = "default",
	-- 			-- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
	-- 			-- ["<C-e>"] = { "hide", "fallback" },
	-- 			-- ["<CR>"] = {},
	-- 			-- ["<C-y>"] = { "select_and_accept", "fallback" },
	-- 			-- ["<Right>"] = { "select_and_accept", "fallback" },
	-- 			--
	-- 			-- ["<Tab>"] = { "snippet_forward", "fallback" },
	-- 			-- ["<S-Tab>"] = { "snippet_backward", "fallback" },
	-- 			--
	-- 			-- ["<Up>"] = { "select_prev", "fallback" },
	-- 			-- ["<Down>"] = { "select_next", "fallback" },
	-- 			-- ["<C-p>"] = { "select_prev", "fallback" },
	-- 			-- ["<C-n>"] = { "select_next", "fallback" },
	-- 			--
	-- 			-- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
	-- 			-- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
	-- 		},
	-- 		list = {
	-- 			selection = "manual",
	-- 		},
	-- 		sources = {
	-- 			default = { "lsp", "path", "snippets", "buffer" },
	-- 			-- optionally disable cmdline completions
	-- 			-- cmdline = {},
	-- 		},
	-- 	},
	-- },
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
}
