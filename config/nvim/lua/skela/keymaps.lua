local opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, silent = true, expr = true }
local term_opts = { silent = true }

-- Shorten function name
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

keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>ft", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)

keymap("n", "<C-p>", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)

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