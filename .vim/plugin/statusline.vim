if exists("g:loaded_dotfiles_statusline")
    finish
endif
let g:loaded_dotfiles_statusline = 1

if !exists("+statusline")
    finish
endif

function! DotfilesStatuslineMode() abort
    let l:mode = mode(1)

    if l:mode =~# "^n"
        return "NORMAL"
    elseif l:mode =~# "^i"
        return "INSERT"
    elseif l:mode ==# "v"
        return "VISUAL"
    elseif l:mode ==# "V"
        return "VISUAL LINE"
    elseif l:mode ==# "\<C-v>"
        return "VISUAL BLOCK"
    elseif l:mode ==# "s"
        return "SELECT"
    elseif l:mode ==# "S"
        return "SELECT LINE"
    elseif l:mode ==# "\<C-s>"
        return "SELECT BLOCK"
    elseif l:mode =~# "^Rv"
        return "VIRTUAL REPLACE"
    elseif l:mode =~# "^R"
        return "REPLACE"
    elseif l:mode =~# "^c"
        return "COMMAND"
    elseif l:mode =~# "^t"
        return "TERMINAL"
    elseif l:mode =~# "^r"
        return "PROMPT"
    elseif l:mode ==# "!"
        return "SHELL"
    endif

    return toupper(l:mode)
endfunction

function! s:update_mode_color() abort
    let l:mode = mode(1)

    if l:mode =~# "^i"
        let l:color = "#3fb950"
        let l:cterm = 35
    elseif l:mode =~# "^[vV\x16sS\x13]"
        let l:color = "#d29922"
        let l:cterm = 136
    elseif l:mode =~# "^R"
        let l:color = "#ff7b72"
        let l:cterm = 203
    elseif l:mode =~# "^c"
        let l:color = "#d2a8ff"
        let l:cterm = 183
    elseif l:mode =~# "^t"
        let l:color = "#f0883e"
        let l:cterm = 208
    else
        let l:color = "#58a6ff"
        let l:cterm = 75
    endif

    if exists("s:last_mode_color") && s:last_mode_color ==# l:color
        return
    endif
    let s:last_mode_color = l:color

    execute "highlight StatusLineMode"
                \ . " guifg=#0d1117 guibg=" . l:color
                \ . " ctermfg=232 ctermbg=" . l:cterm
                \ . " gui=NONE cterm=NONE term=NONE"
    execute "highlight StatusLinePosition"
                \ . " guifg=#0d1117 guibg=" . l:color
                \ . " ctermfg=232 ctermbg=" . l:cterm
                \ . " gui=NONE cterm=NONE term=NONE"
endfunction

function! s:update_git_branch() abort
    if !executable("git")
        let b:dotfiles_git_branch = ""
        return
    endif

    let l:directory = empty(expand("%:p")) ? getcwd() : expand("%:p:h")
    let l:branches = systemlist(
                \ "git -C " . shellescape(l:directory)
                \ . " branch --show-current 2>/dev/null"
                \ )
    let b:dotfiles_git_branch = v:shell_error || empty(l:branches)
                \ ? ""
                \ : l:branches[0]
endfunction

function! DotfilesStatuslineGitBranch() abort
    if !exists("b:dotfiles_git_branch")
        call s:update_git_branch()
    endif

    if empty(b:dotfiles_git_branch)
        return ""
    endif

    let l:prefix = &encoding ==# "utf-8" ? " " : "git: "
    return l:prefix . b:dotfiles_git_branch . "  "
endfunction

let &statusline = "%#StatusLineMode# %{DotfilesStatuslineMode()} "
            \ . "%#StatusLineBranch# %{DotfilesStatuslineGitBranch()}"
            \ . "%#StatusLineFile# %f%m%r "
            \ . "%="
            \ . "%#StatusLineMeta# %{&filetype} "
            \ . "%#StatusLinePosition# %l:%c "

augroup DotfilesStatusline
    autocmd!
    autocmd BufEnter,BufWritePost * call <SID>update_git_branch()
    if exists("##ModeChanged")
        autocmd ModeChanged * call <SID>update_mode_color()
    else
        autocmd CursorMoved,CursorMovedI,InsertEnter,InsertLeave *
                    \ call <SID>update_mode_color()
    endif
augroup END

call s:update_mode_color()
