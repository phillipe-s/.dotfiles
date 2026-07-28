" Native Vim version of the GitHub Dark Default palette used by Neovim.

highlight clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "github_dark_default"
set background=dark

" Editor
highlight Normal         guifg=#e6edf3 guibg=NONE    gui=NONE
highlight NormalNC       guifg=#e6edf3 guibg=NONE    gui=NONE
highlight Cursor         guifg=#0d1117 guibg=#e6edf3 gui=NONE
highlight CursorLine     guifg=NONE    guibg=#171b22 gui=NONE cterm=NONE term=NONE
highlight CursorColumn   guifg=NONE    guibg=#171b22 gui=NONE
highlight ColorColumn    guifg=NONE    guibg=#171b22 gui=NONE
highlight LineNr         guifg=#6e7681 guibg=NONE    gui=NONE cterm=NONE term=NONE
highlight CursorLineNr   guifg=#e6edf3 guibg=NONE    gui=NONE cterm=NONE term=NONE
highlight FoldColumn     guifg=#6e7681 guibg=NONE    gui=NONE
highlight SignColumn     guifg=#6e7681 guibg=NONE    gui=NONE
highlight Folded         guifg=#6e7681 guibg=#171b22 gui=NONE
highlight EndOfBuffer    guifg=#0d1117 guibg=NONE    gui=NONE
highlight NonText        guifg=#8b949e guibg=NONE    gui=NONE
highlight SpecialKey     guifg=#484f58 guibg=NONE    gui=NONE
highlight Visual         guifg=NONE    guibg=#17335a gui=NONE
highlight Search         guifg=#e6edf3 guibg=#3c3b33 gui=NONE
highlight IncSearch      guifg=#161b22 guibg=#f0883e gui=NONE
highlight MatchParen     guifg=#e6edf3 guibg=#1e4273 gui=bold

" Interface
highlight StatusLine         guifg=#b1bac4 guibg=#04070d gui=NONE cterm=NONE term=NONE
highlight StatusLineNC       guifg=#7d8590 guibg=#0d1117 gui=NONE cterm=NONE term=NONE
highlight StatusLineMode     guifg=#0d1117 guibg=#2f81f7 gui=NONE cterm=NONE term=NONE
highlight StatusLineBranch   guifg=#b1bac4 guibg=#04070d gui=NONE cterm=NONE term=NONE
highlight StatusLineFile     guifg=#b1bac4 guibg=#04070d gui=NONE cterm=NONE term=NONE
highlight StatusLineMeta     guifg=#b1bac4 guibg=#04070d gui=NONE cterm=NONE term=NONE
highlight StatusLinePosition guifg=#0d1117 guibg=#2f81f7 gui=NONE cterm=NONE term=NONE
highlight VertSplit      guifg=#161b22 guibg=NONE    gui=NONE
highlight Pmenu          guifg=#e6edf3 guibg=#04070d gui=NONE
highlight PmenuSel       guifg=#e6edf3 guibg=#1c3d6a gui=NONE
highlight WildMenu       guifg=#e6edf3 guibg=#04070d gui=NONE
highlight Directory      guifg=#d2a8ff guibg=NONE    gui=NONE
highlight Title          guifg=#79c0ff guibg=NONE    gui=bold
highlight WarningMsg     guifg=#d29922 guibg=NONE    gui=NONE
highlight ErrorMsg       guifg=#f85149 guibg=NONE    gui=NONE
highlight MoreMsg        guifg=#2f81f7 guibg=NONE    gui=NONE
highlight Question       guifg=#2f81f7 guibg=NONE    gui=NONE
highlight ModeMsg        guifg=#d29922 guibg=NONE    gui=NONE

" Syntax
highlight Comment        guifg=#8b949e guibg=NONE gui=NONE
highlight Constant       guifg=#79c0ff guibg=NONE gui=NONE
highlight String         guifg=#a5d6ff guibg=NONE gui=NONE
highlight Character      guifg=#a5d6ff guibg=NONE gui=NONE
highlight Number         guifg=#79c0ff guibg=NONE gui=NONE
highlight Float          guifg=#79c0ff guibg=NONE gui=NONE
highlight Boolean        guifg=#79c0ff guibg=NONE gui=NONE
highlight Identifier     guifg=#e6edf3 guibg=NONE gui=NONE
highlight Function       guifg=#d2a8ff guibg=NONE gui=NONE
highlight Statement      guifg=#ff7b72 guibg=NONE gui=NONE
highlight Conditional    guifg=#ff7b72 guibg=NONE gui=NONE
highlight Repeat         guifg=#ff7b72 guibg=NONE gui=NONE
highlight Label          guifg=#ff7b72 guibg=NONE gui=NONE
highlight Operator       guifg=#79c0ff guibg=NONE gui=NONE
highlight Keyword        guifg=#ff7b72 guibg=NONE gui=NONE
highlight Exception      guifg=#ff7b72 guibg=NONE gui=NONE
highlight PreProc        guifg=#ff7b72 guibg=NONE gui=NONE
highlight Include        guifg=#ff7b72 guibg=NONE gui=NONE
highlight Define         guifg=#ff7b72 guibg=NONE gui=NONE
highlight Macro          guifg=#ff7b72 guibg=NONE gui=NONE
highlight PreCondit      guifg=#ff7b72 guibg=NONE gui=NONE
highlight Type           guifg=#ffa657 guibg=NONE gui=NONE
highlight StorageClass   guifg=#ffa657 guibg=NONE gui=NONE
highlight Structure      guifg=#ffa657 guibg=NONE gui=NONE
highlight Typedef        guifg=#ffa657 guibg=NONE gui=NONE
highlight Special        guifg=#e6edf3 guibg=NONE gui=NONE
highlight Underlined     guifg=#2f81f7 guibg=NONE gui=underline
highlight Error          guifg=#f85149 guibg=NONE gui=NONE
highlight Todo           guifg=#0d1117 guibg=#2f81f7 gui=NONE

" Diffs
highlight DiffAdd        guifg=#3fb950 guibg=#10231c gui=NONE
highlight DiffChange     guifg=#d29922 guibg=#231e14 gui=NONE
highlight DiffDelete     guifg=#f85149 guibg=#2c171b gui=NONE
highlight DiffText       guifg=#e6edf3 guibg=#171b22 gui=NONE

" Approximate palette for remote terminals without true-color Vim support.
if (!exists("+termguicolors") || !&termguicolors) && &t_Co >= 256
    highlight Normal         ctermfg=255 ctermbg=NONE cterm=NONE
    highlight CursorLine     ctermfg=NONE ctermbg=234  cterm=NONE
    highlight CursorColumn   ctermfg=NONE ctermbg=234  cterm=NONE
    highlight ColorColumn    ctermfg=NONE ctermbg=234  cterm=NONE
    highlight LineNr         ctermfg=242  ctermbg=NONE cterm=NONE
    highlight CursorLineNr   ctermfg=255  ctermbg=NONE cterm=NONE
    highlight FoldColumn     ctermfg=242  ctermbg=NONE cterm=NONE
    highlight SignColumn     ctermfg=242  ctermbg=NONE cterm=NONE
    highlight Folded         ctermfg=242  ctermbg=234  cterm=NONE
    highlight NonText        ctermfg=245  ctermbg=NONE cterm=NONE
    highlight SpecialKey     ctermfg=239  ctermbg=NONE cterm=NONE
    highlight Visual         ctermfg=NONE ctermbg=24   cterm=NONE
    highlight Search         ctermfg=255  ctermbg=58   cterm=NONE
    highlight IncSearch      ctermfg=234  ctermbg=208  cterm=NONE
    highlight MatchParen     ctermfg=255  ctermbg=24   cterm=bold

    highlight StatusLine         ctermfg=250 ctermbg=232 cterm=NONE
    highlight StatusLineNC       ctermfg=243 ctermbg=233 cterm=NONE
    highlight StatusLineMode     ctermfg=232 ctermbg=75  cterm=NONE
    highlight StatusLineBranch   ctermfg=250 ctermbg=232 cterm=NONE
    highlight StatusLineFile     ctermfg=250 ctermbg=232 cterm=NONE
    highlight StatusLineMeta     ctermfg=250 ctermbg=232 cterm=NONE
    highlight StatusLinePosition ctermfg=232 ctermbg=75  cterm=NONE
    highlight VertSplit          ctermfg=234 ctermbg=NONE cterm=NONE
    highlight Pmenu              ctermfg=255 ctermbg=232  cterm=NONE
    highlight PmenuSel           ctermfg=255 ctermbg=24   cterm=NONE
    highlight WildMenu           ctermfg=255 ctermbg=232  cterm=NONE
    highlight Directory          ctermfg=183 ctermbg=NONE cterm=NONE
    highlight Title              ctermfg=117 ctermbg=NONE cterm=bold
    highlight WarningMsg         ctermfg=136 ctermbg=NONE cterm=NONE
    highlight ErrorMsg           ctermfg=203 ctermbg=NONE cterm=NONE

    highlight Comment        ctermfg=245 ctermbg=NONE cterm=NONE
    highlight Constant       ctermfg=117 ctermbg=NONE cterm=NONE
    highlight String         ctermfg=153 ctermbg=NONE cterm=NONE
    highlight Character      ctermfg=153 ctermbg=NONE cterm=NONE
    highlight Number         ctermfg=117 ctermbg=NONE cterm=NONE
    highlight Float          ctermfg=117 ctermbg=NONE cterm=NONE
    highlight Boolean        ctermfg=117 ctermbg=NONE cterm=NONE
    highlight Identifier     ctermfg=255 ctermbg=NONE cterm=NONE
    highlight Function       ctermfg=183 ctermbg=NONE cterm=NONE
    highlight Statement      ctermfg=203 ctermbg=NONE cterm=NONE
    highlight Conditional    ctermfg=203 ctermbg=NONE cterm=NONE
    highlight Repeat         ctermfg=203 ctermbg=NONE cterm=NONE
    highlight Label          ctermfg=203 ctermbg=NONE cterm=NONE
    highlight Operator       ctermfg=117 ctermbg=NONE cterm=NONE
    highlight Keyword        ctermfg=203 ctermbg=NONE cterm=NONE
    highlight Exception      ctermfg=203 ctermbg=NONE cterm=NONE
    highlight PreProc        ctermfg=203 ctermbg=NONE cterm=NONE
    highlight Type           ctermfg=215 ctermbg=NONE cterm=NONE
    highlight StorageClass   ctermfg=215 ctermbg=NONE cterm=NONE
    highlight Structure      ctermfg=215 ctermbg=NONE cterm=NONE
    highlight Typedef        ctermfg=215 ctermbg=NONE cterm=NONE
    highlight Special        ctermfg=255 ctermbg=NONE cterm=NONE
    highlight Error          ctermfg=203 ctermbg=NONE cterm=NONE
    highlight Todo           ctermfg=233 ctermbg=33   cterm=NONE
endif
