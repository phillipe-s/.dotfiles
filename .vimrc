set termguicolors
colorscheme github_dark_default

" FILES
syntax enable
filetype plugin on
filetype indent on

" LEADER
let mapleader = " "
let maplocalleader = " "

" LINES
set number
set relativenumber
set numberwidth=5
set cursorline
set nowrap
set scrolloff=10
set sidescrolloff=10
set sidescroll=1        " makes horizontal scrolling move on column at a time

" CURSOR
set guicursor=n-v:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve-c:ver25-blinkwait700-blinkoff400-blinkon250,r-cr-o:hor20-blinkwait700-blinkoff400-blinkon250

if !has("gui_running")
    let &t_SI = "\<Esc>[5 q"  " Insert: blinking bar
    let &t_SR = "\<Esc>[3 q"  " Replace: blinking bar
    let &t_EI = "\<Esc>[1 q"  " Normal: blinking block

    let &t_ti .= "\<Esc>[1 q" " Set Normal cursor when Vim starts
    let &t_te .= "\<Esc>[0 q" " Restore terminal default when Vim exits
endif

" TABS & INDENTATION
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent
set smarttab

" SEARCH
set ignorecase
set smartcase
set incsearch
set hlsearch

" EDITOR
set showmatch                   " highlight the matching bracket when closing it
set matchtime=0                 " set it so the matching is instant
set laststatus=2                " always show the status line
set hidden                      " allows leaving a modified buffer without saving it
set autoread                    " auto reloads a file when it is changed elsewhere 
set display=lastline            " when the final line does not fit in the window, display as much of it as possible
set nojoinspaces                " joining lines with `J` inserts one line between them
set nostartofline               " preserves the curor's column when using line changing motions e.g. `Ctrl-D` or `Ctrl-U`
silent! set switchbuf=uselast  
set splitright
set splitbelow
set foldmethod=syntax
set foldlevel=99
set foldlevelstart=99
set foldcolumn=0
set fillchars = "eob: ,fold: "
set signcolumn=no
set noshowmode                  " hides mode message e.g. -- INSERT --

set viewoptions=folds,cursor    " controls what :mkview and :loadview restore
if !isdirectory(expand(&viewdir))
    call mkdir(expand(&viewdir), "p", 0700)
endif

augroup PersistFileView
    autocmd!
    autocmd BufWinLeave * if &buftype ==# "" && !empty(expand("%:p")) | silent! mkview! | endif
    autocmd BufWinEnter * if &buftype ==# "" && !empty(expand("%:p")) | silent! loadview | endif
augroup END

" HISTORY
set nowritebackup
set noswapfile
set history=10000

set undofile
if !isdirectory(expand("~/.vim/undo"))
    call mkdir(expand("~/.vim/undo"), "p", 0700)
endif
set undodir=~/.vim/undo//

" OTHER 
set updatetime=200
set mouse=a
set iskeyword+=-
set belloff=all
set ttimeout
set ttimeoutlen=50
set complete=.,w,b,u,t              " completion sources
set completeopt=menu                " shows completion menu
silent! set completeopt+=popup      " support older vim versions
silent! set autocomplete
silent! set autocompletedelay=100
set nrformats=bin,hex               " controls number formats `Ctrl-A` and `Ctrl-D` recognise when incremending/decrementing
set wildmenu                        " enables a visual list of command-line completions e.g. pressing `Tab` after `:edit`
set wildoptions=pum,tagfile
set backspace=indent,eol,start      " better backspace behaviour

" CLIPBOARD
if empty($SSH_CONNECTION)
    " Use the native system clipboard when Vim is running locally.
    if has("unnamedplus")
        set clipboard=unnamedplus
    elseif has("clipboard")
        " macOS Vim exposes its native pasteboard through the * register.
        set clipboard=unnamed
    endif
else
    " Prefer Vim's bundled OSC 52 provider when it is available.
    let s:osc52_package = globpath(&packpath, "pack/*/opt/osc52")
    if !empty(s:osc52_package) && exists("+clipmethod")
        let g:osc52_disable_paste = v:true
        packadd osc52
        set clipmethod+=osc52
        set clipboard=unnamedplus
    else
        " Vim versions without the bundled provider can still send OSC 52
        " directly to the local terminal after each yank.
        function! s:osc52_copy(lines) abort
            let l:encoded = substitute(system("base64", join(a:lines, "\n")), "\\s", "", "g")
            call writefile(["\x1b]52;c;" . l:encoded . "\x07"], "/dev/tty", "b")
        endfunction

        augroup RemoteClipboard
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# "y" | call s:osc52_copy(v:event.regcontents) | endif
        augroup END
    endif
endif

" UTILS 
function! s:format_buffer() abort
    let l:view = winsaveview()
    silent keepjumps normal! gg=G
    call winrestview(l:view)
endfunction

" Highlight yanked text
if !empty(globpath(&packpath, "pack/*/opt/hlyank"))
    highlight YankHighlight guifg=#161b22 guibg=#f0883e gui=NONE ctermfg=234 ctermbg=208 cterm=NONE
    let g:hlyank_hlgroup = "YankHighlight"
    let g:hlyank_duration = 50
    packadd hlyank
endif

" KEYMAPS
inoremap jk <Esc>
nnoremap <leader>w :<C-u>write<CR>
nnoremap <leader>q :<C-u>quit<CR>
nnoremap <leader>f :<C-u>call <SID>format_buffer()<CR>

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
