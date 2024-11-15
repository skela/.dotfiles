local luasnip_fix_augroup = vim.api.nvim_create_augroup("MyLuaSnipHistory", { clear = true })
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		if
			((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
			and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
			and not require("luasnip").session.jump_active
		then
			require("luasnip").unlink_current()
		end
	end,
	group = luasnip_fix_augroup,
})

return {
	{
		"nvim-cmp",
		optional = true,
		dependencies = { "saadparwaiz1/cmp_luasnip" },
		opts = function(_, opts)
			opts.snippet = {
				expand = function(args) require("luasnip").lsp_expand(args.body) end,
			}
			table.insert(opts.sources, { name = "luasnip" })
		end,
		keys = {
			-- ["<tab>"] = function(callback) callback() end,
			["<tab>"] = function(fallback)
				if require("cmp").visible() then
					require("cmp").select_next_item()
				elseif require("luasnip").expand_or_jumpable() then
					require("luasnip").expand_or_jump()
				else
					fallback()
				end
			end,
		},
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
}
