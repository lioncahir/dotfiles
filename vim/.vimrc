syntax on
filetype plugin indent on
set number relativenumber
set backspace=indent,eol,start
set incsearch
set ignorecase
set hlsearch
set mouse=a
set termguicolors
set spellcapcheck=

"Use system clipboard
set clipboard=unnamedplus

"Do not update buffer with replaced text
vnoremap p "_dP

"Wrapping
set wrap linebreak
set textwidth=100

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

"Tab settings
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

"Fix problem with undercurl in Alacritty terminal
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

"Plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/goyo.vim'
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'tomasiser/vim-code-dark'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
call plug#end()

"Plugin settings
let g:goyo_width=100
let g:gruvbox_italic=1
"let g:gruvbox_contrast_dark='hard'

"LightLine
set laststatus=2
set noshowmode
set ttimeout ttimeoutlen=50

"Color scheme settings
set background=dark
let g:codedark_italics=1
let g:codedark_modern=1
colorscheme gruvbox

let g:lightline = {'colorscheme' : 'gruvbox'}

