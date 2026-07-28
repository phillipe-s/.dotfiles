export EDITOR=nvim
export VISUAL=nvim

# === History ===
HISTSIZE=5000                           # commands stored in memory
HISTFILE="$XDG_STATE_HOME/zsh/history"  # history file
SAVEHIST=$HISTSIZE                      # commands saved to history file
setopt appendhistory                    # appends commands to history file instead of overwriting
setopt sharehistory                     # shares commands across active terminal sessions
setopt hist_ignore_space                # type a space before a command to not save it to history
setopt hist_ignore_all_dups             # removes older duplicate commands
setopt hist_save_no_dups                # older duplicate commands are removed
setopt hist_ignore_dups                 # only saves new commands
setopt hist_find_no_dups                # skips over duplicates when searching history
setopt hist_reduce_blanks               # cleans up accidental extra spaces

# === Key Binds ===
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# === Other ===
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

if command -v fnm &>/dev/null; then
    eval "$(fnm env --use-on-cd --shell zsh)"
fi

# === Plugins ===
ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"

# --- Plugins ---
if [[ -r "$ZINIT_HOME/zinit.zsh" ]]; then
    source "$ZINIT_HOME/zinit.zsh"

    zinit light zsh-users/zsh-completions

    autoload -Uz compinit
    compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"

    zinit light Aloxaf/fzf-tab
    zinit snippet OMZP::git
    zinit light zsh-users/zsh-autosuggestions

    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*' menu no
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --group-directories-first $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --group-directories-first $realpath'

    zinit light zsh-users/zsh-syntax-highlighting
fi

# === Aliases ===
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --grid'
    alias tree='eza --group-directories-first --tree -L 3 '
else
    alias ls='ls --color'
fi

alias ..='cd ..'
alias c='clear'

alias n='nvim'
alias gg='lazygit'
