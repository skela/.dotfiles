local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")

local servers = {
	"pyright",
	"dartls",
	"sourcekit",
	"rust_analyzer",
}

lspconfig.lua_ls.setup
{
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		runtime = {
			version = "LuaJIT", -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
		},
		diagnostics = {
			globals = {"vim"}, -- Get the language server to recognize the `vim` global
		},
		Lua = {
			diagnostics = {
				globals = {"vim"}, -- Get the language server to recognize the `vim` global
			},
		},

		workspace = {
			library = vim.api.nvim_get_runtime_file("", true), -- Make the server aware of Neovim runtime files
		},
		telemetry = {
			enable = false, -- Do not send telemetry data containing a randomized but unique identifier
		},
	}
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup
	{
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

