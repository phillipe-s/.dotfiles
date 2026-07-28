set termguicolors

syntax enable
try
    colorscheme github_dark_default
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
endtry
filetype plugin indent on

" Apply settings that are not available in every Vim version.
function! s:try_set(setting) abort
    try
        execute "set " . a:setting
    catch /^Vim\%((\a\+)\)\=:E\(474\|518\):/
    endtry
endfunction

" Leader
let mapleader = " "
let maplocalleader = " "

" Lines
set number
set relativenumber
set numberwidth=5
set cursorline
set nowrap
set scrolloff=10
set sidescrolloff=10
set sidescroll=1

" Cursor
set guicursor=n-v:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve-c:ver25-blinkwait700-blinkoff400-blinkon250,r-cr-o:hor20-blinkwait700-blinkoff400-blinkon250

if !has("gui_running")
    if exists("+t_SI") && empty(&t_SI)
        let &t_SI = "\<Esc>[5 q"
    endif
    if exists("+t_SR") && empty(&t_SR)
        let &t_SR = "\<Esc>[3 q"
    endif
    if exists("+t_EI") && empty(&t_EI)
        let &t_EI = "\<Esc>[1 q"
    endif

    if exists("##VimEnter")
        augroup TerminalCursorShape
            autocmd!
            autocmd VimEnter * silent! execute "normal! i\<Esc>"
        augroup END
    endif

endif

" Tabs and indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent
set smarttab

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Editor
set showmatch
set laststatus=2
set hidden
set autoread
set display=lastline
set nojoinspaces
set nostartofline
call s:try_set("switchbuf=uselast")
set splitright
set splitbelow
set foldmethod=syntax
set foldlevel=99
set foldlevelstart=99
set foldcolumn=0
set fillchars = "eob: ,fold: "
set viewoptions=folds,cursor
set signcolumn=no
set noshowmode

" History
set nowritebackup
set noswapfile
set history=10000

set undofile
if !isdirectory(expand("~/.vim/undo"))
    call mkdir(expand("~/.vim/undo"), "p", 0700)
endif
set undodir=~/.vim/undo//

" Other
set updatetime=200
set mouse=a
set iskeyword+=-
set belloff=all
set ttimeout
set ttimeoutlen=50
set complete-=i
set completeopt=menu
call s:try_set("completeopt+=popup")
call s:try_set("autocomplete")
call s:try_set("autocompletedelay=100")
set nrformats=bin,hex
set wildmenu
set wildoptions=
call s:try_set("wildoptions+=pum")
call s:try_set("wildoptions+=tagfile")
set clipboard=unnamedplus

" Utility
inoremap jk <Esc>
nnoremap <leader>w :<C-u>write<CR>
nnoremap <leader>q :<C-u>quit<CR>

" Keep the cursor centered
nnoremap J mzJ`z
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Move and indent selections
xnoremap J :<C-u>silent! '<,'>move '>+1 \| silent! normal! gv=gv<CR>
xnoremap K :<C-u>silent! '<,'>move '<-2 \| silent! normal! gv=gv<CR>
xnoremap <S-Tab> <gv
xnoremap <Tab> >gv

" Search
nnoremap <Esc> :<C-u>nohlsearch<CR>

" Copy and paste
xnoremap <leader>p "_dP
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap x "_x

" Splits
nnoremap <leader>s :<C-u>vsplit<CR>
nnoremap <leader>S :<C-u>split<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
