local utils = require("skela.utils")
local keymapper = require("skela.keymaps")

require("nvim-lsp-installer").setup({
    automatic_installation = true,
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})


local on_attach = function(client,bufnr)
	keymapper.lsp_on_attach(client,bufnr)
end

local cfg = utils.require_safely("lspconfig")
if not cfg then return end

cfg.pyright.setup { on_attach = on_attach }
--cfg.dartls.setup { on_attach = on_attach }
--  cfg.sourcekit_lsp.setup { on_attach = on_attach }

cfg.lua_ls.setup
{
	on_attach = on_attach,
	settings = { Lua = { diagnostics = { globals = { "vim" } } } }
}

if utils.has_module("telescope") then
	vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
end

