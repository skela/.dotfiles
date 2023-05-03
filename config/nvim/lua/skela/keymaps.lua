local keymapper = {}

function keymapper.defaults()
	local opts = { noremap = true, silent = true }
	local expr_opts = { noremap = true, silent = true, expr = true }
	local term_opts = { silent = true }

	local keymap = vim.api.nvim_set_keymap

	--Remap space as leader key
	keymap("", "<Space>", "<Nop>", opts)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Modes
	--   normal_mode = "n",
	--   insert_mode = "i",
	--   visual_mode = "v",
	--   visual_block_mode = "x",
	--   term_mode = "t",
	--   command_mode = "c",

	keymap("n","<C-b>",":NvimTreeToggle<CR>",opts)

	keymap("n","<C-`>","<CMD>lua require('FTerm').toggle()<CR>",opts)
	keymap("t","<C-`>","<CMD>lua require('FTerm').toggle()<CR>",opts)

	keymap("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<cr>", opts)
	keymap("n", "<leader>ft", "<cmd>Telescope live_grep<cr>", opts)
	keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)

	keymap("n", "<C-p>", "<cmd>Telescope find_files hidden=true<cr>", opts)
	keymap("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
	keymap("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", opts)
	keymap("n", "<C-w>", "<cmd>Telescope buffers<cr>", opts)

	keymap("n", "<leader>/", "v:lua.require'commented'.commented_line()", expr_opts)
	keymap("v", "<leader>/", "v:lua.require'commented'.commented_line()", expr_opts)

	--keymap("n", "<C-_>", "v:lua.require'commented'.commented_line()", expr_opts)
	--keymap("v", "<C-_>", "v:lua.require'commented'.commented_line()", expr_opts)

	-- Normal --
	-- Better window navigation
	keymap("n", "<C-h>", "<C-w>h", opts)
	keymap("n", "<C-j>", "<C-w>j", opts)
	keymap("n", "<C-k>", "<C-w>k", opts)
	keymap("n", "<C-l>", "<C-w>l", opts)

	keymap("n", "<leader>e", ":Lex 30<cr>", opts)

	-- Resize with arrows
	--keymap("n", "<CS-Up>", ":resize +2<CR>", opts)
	--keymap("n", "<CS-Down>", ":resize -2<CR>", opts)
	--keymap("n", "<CS><Left>", ":vertical resize -2<CR>", opts)
	--keymap("n", "<CS-Right>", ":vertical resize +2<CR>", opts)

	-- Search (Clear Highlight)
	keymap("n", "<esc><esc>", ":noh<CR>", opts)

	-- Navigate buffers
	keymap("n", "<S-l>", ":bnext<CR>", opts)
	keymap("n", "<S-h>", ":bprevious<CR>", opts)

	-- Save file
	keymap("n","<C-S>",":update<CR>",opts)
	keymap("v","<C-S>","<C-C>:update<CR>",opts)
	keymap("i","<C-S>","<C-O>:update<CR>",opts)

	-- Insert --
	-- Press jk fast to enter
	keymap("i", "jk", "<ESC>", opts)

	-- Visual --
	-- Stay in indent mode
	keymap("v", "<", "<gv", opts)
	keymap("v", ">", ">gv", opts)

	-- Move text up and down
	keymap("v", "<A-j>", ":m .+1<CR>==", opts)
	keymap("v", "<A-k>", ":m .-2<CR>==", opts)
	keymap("v", "p", '"_dP', opts)

	-- Visual Block --
	-- Move text up and down
	keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
	keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
	keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
	keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

	-- Terminal --
	-- Better terminal navigation
	keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
	keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
	keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
	keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)
end

function keymapper.lsp_on_attach(_,bufnr)

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

function keymapper.nvim_tree()
	-- https://github.com/nvim-tree/nvim-tree.lua/blob/b4d704e88d57f2c7889aa01093038a7a5a4f3c5d/doc/nvim-tree-lua.txt#L1210
	return
	{
		custom_only = false,
		list = {
			{ key = "a", action = "create" },
			{ key = "p", action = "parent_node" },
			{ key = "u", action = "dir_up" },
			{ key = "o", action = "cd" },
			{ key = "gg", action = "cd" },
			{ key = "gp", action = "dir_up" },
		},
	}
end

return keymapper
