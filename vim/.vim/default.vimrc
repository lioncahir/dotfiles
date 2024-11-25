syntax on
filetype plugin indent on
set nocompatible
set number relativenumber
set backspace=indent,eol,start
set incsearch
set ignorecase
set hlsearch
set mouse=a
set termguicolors
set spellcapcheck=
set display+=lastline

"Use system clipboard
set clipboard=unnamedplus

"Do not update buffer with replaced text
vnoremap p "_dP

"Use Y to yank until end of line
nnoremap Y y$

"Wrapping
set wrap linebreak
set textwidth=0

"Use arrows to move between wrapped lines
nmap <up> gk
nmap <down> gj
nmap <silent> <home> g0
nmap <silent> <end> g$

"Autoclose brackets
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

"Split settigs
set splitright
set splitbelow
nnoremap <C-left> <C-w><left>
nnoremap <C-right> <C-w><right>
nnoremap <C-up> <C-w><up>
nnoremap <C-down> <C-w><down>

"Tab settings
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"

"Plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'itchyny/lightline.vim'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'ap/vim-css-color'
call plug#end()

"Plugin settings
let g:goyo_width=70

"LightLine
set laststatus=2
set noshowmode
set ttimeout ttimeoutlen=50
