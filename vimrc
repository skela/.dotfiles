
" Better copy and paste
set pastetoggle=<F2>
set clipboard=unnamed

" Mouse and backspace
set mouse=a  	"on OSX press ALT and click
set bs=2		" make backspace behave like normal again

" Rebind <Leader> key <Leader> key is by default the <\> key
"let mapleader=","

" Quicksave commands
noremap <C-Z> :update<CR>
vnoremap <C-Z> <C-C>:update<CR>
inoremap <C-Z> <C-O>:update<CR>

" Bind Ctrl+<movement> keys to move around the windows, instead of using
" Ctrl+w + <movement>
""map <c-j> <c-w>j
""map <c-k> <c-w>k
""map <c-l> <c-w>l
""map <c-h> <c-w>h

" Easier movement between tabs
map <Leader>[ <esc>:tabprevious<CR>
map <Leader>] <esc>:tabnext<CR>

" Map Sort function to a key
vnoremap <Leader>s :sort<CR>

" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script
set t_Co=256
color wombat256mod

" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype off
filetype plugin indent on
syntax on

" Showing line numbers and length
set number	"show line numbers

" Use spaces instead of TABs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Python 
autocmd FileType python set omnifunc=pythoncomplete#Complete

