
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

local add_keymaps = function(bufnr)

	local function add_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	local opts = { noremap=true, silent=true }

	add_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	add_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

	add_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  add_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  add_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  add_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  add_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  add_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  add_keymap("n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  add_keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  add_keymap("n", "gl", '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>', opts)
  add_keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  add_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

end

local on_attach = function(_,bufnr)

	add_keymaps(bufnr)

end

local cfg = require("lspconfig")

cfg.pyright.setup { on_attach = on_attach }
cfg.dartls.setup { on_attach = on_attach }

cfg.sumneko_lua.setup
{
	on_attach = on_attach,
	settings = { Lua = { diagnostics = { globals = { "vim" } } } }
}

