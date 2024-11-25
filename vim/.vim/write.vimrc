runtime default.vimrc

"Color scheme settings
colorscheme catppuccin_latte

"Red undercurl color for spell check
hi SpellBad cterm=undercurl ctermbg=NONE ctermul=red gui=undercurl guisp=red
hi Comment cterm=italic

"Keybindings for writing
nnoremap ZZ :wqa<cr>
nnoremap ZQ :qa<cr>
map <F7> :setlocal spell! spelllang=sk<cr>

"Start Goyo
autocmd VimEnter * Goyo 70
