set background=dark
set clipboard=unnamedplus
"set cursorline
set noerrorbells
set nowrap
set hidden
set number
set relativenumber
set completeopt=noinsert,menuone,noselect
set mouse=a
set splitbelow splitright
set title
set wildmenu
set nohlsearch
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=yes

call plug#begin("~/.config/nvim/plugged")
Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'mbbill/undotree'
Plug 'akinsho/flutter-tools.nvim'
call plug#end()

set termguicolors
colorscheme gruvbox
highlight Normal guibg=none

let mapleader = " "
nnoremap <leader>u :UndotreeToggle<CR>
