#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
HOMEBREW_INSTALLER=""

usage() {
  cat <<'USAGE'
Usage: scripts/bootstrap.sh [options]

Bootstrap this dotfiles repo on a new machine.

Options:
  --skip-brew       Do not install Homebrew or run brew bundle.
  --skip-zinit      Do not install the Zinit plugin manager.
  --skip-tpm        Do not install Tmux Plugin Manager or tmux plugins.
  --skip-stow       Do not create symlinks with stow.
  --yes             Answer yes to bootstrap prompts.
  -h, --help        Show this help message.

The official Homebrew installer decides whether the host is supported and
reports any system prerequisites that must be installed manually.
USAGE
}

log() {
  printf '\033[1;34m==>\033[0m %s\n' "$*"
}

warn() {
  printf '\033[1;33mWARN:\033[0m %s\n' "$*" >&2
}

die() {
  printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2
  exit 1
}

confirm() {
  local prompt="$1"

  if [[ "$ASSUME_YES" == "1" ]]; then
    return 0
  fi

  read -r -p "$prompt [y/N] " reply
  [[ "$reply" =~ ^[Yy]$|^[Yy][Ee][Ss]$ ]]
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

cleanup() {
  if [[ -n "$HOMEBREW_INSTALLER" && -f "$HOMEBREW_INSTALLER" ]]; then
    rm -f -- "$HOMEBREW_INSTALLER"
  fi
}

trap cleanup EXIT

detect_environment() {
  printf '%s (%s)' "$(uname -s)" "$(uname -m)"
}

load_homebrew() {
  local brew_paths=(
    /opt/homebrew/bin/brew
    /usr/local/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew
  )
  local brew_path

  if command_exists brew; then
    return 0
  fi

  for brew_path in "${brew_paths[@]}"; do
    if [[ -x "$brew_path" ]]; then
      eval "$("$brew_path" shellenv)"
      return 0
    fi
  done
}

install_homebrew() {
  local bash_path

  if command_exists brew; then
    return 0
  fi

  command_exists curl || die "curl is required to download Homebrew. Install curl manually, then rerun this bootstrap."

  if ! confirm "Homebrew is not installed. Install it now?"; then
    die "Homebrew is required unless you run with --skip-brew."
  fi

  log "Downloading the official Homebrew installer"
  HOMEBREW_INSTALLER="$(mktemp "${TMPDIR:-/tmp}/homebrew-install.XXXXXX")"
  curl -fsSL "$HOMEBREW_INSTALL_URL" -o "$HOMEBREW_INSTALLER"
  bash_path="$(command -v bash)"

  log "Installing Homebrew"
  if [[ "$ASSUME_YES" == "1" ]]; then
    if ! NONINTERACTIVE=1 "$bash_path" "$HOMEBREW_INSTALLER"; then
      die "Homebrew installation failed. Install the prerequisites reported above, then rerun this bootstrap."
    fi
  else
    if ! "$bash_path" "$HOMEBREW_INSTALLER"; then
      die "Homebrew installation failed. Install the prerequisites reported above, then rerun this bootstrap."
    fi
  fi

  load_homebrew
  command_exists brew || die "Homebrew installed, but brew is still not on PATH. Restart your shell and rerun this script."
}

ensure_xdg_dirs() {
  log "Creating XDG directories"
  mkdir -p \
    "$HOME/.cache" \
    "$HOME/.cache/zsh" \
    "$HOME/.config" \
    "$HOME/.local/bin" \
    "$HOME/.local/share" \
    "$HOME/.local/state" \
    "$HOME/.local/state/zsh"
}

install_brew_bundle() {
  [[ -f "$BREWFILE" ]] || die "Brewfile not found at $BREWFILE"

  install_homebrew

  log "Installing Brewfile dependencies"
  brew bundle --file="$BREWFILE"
}

install_zinit() {
  local xdg_data_home
  local zinit_home

  command_exists git || die "git is required to install Zinit."

  xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  zinit_home="$xdg_data_home/zinit/zinit.git"

  if [[ -d "$zinit_home/.git" ]]; then
    log "Zinit already installed"
    return 0
  fi

  log "Installing Zinit"
  mkdir -p "$(dirname "$zinit_home")"
  git clone https://github.com/zdharma-continuum/zinit.git "$zinit_home"
}

install_tpm() {
  local tmux_conf
  local tpm_home

  command_exists git || die "git is required to install Tmux Plugin Manager."

  tmux_conf="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
  tpm_home="$HOME/.tmux/plugins/tpm"

  if [[ -d "$tpm_home/.git" ]]; then
    log "Tmux Plugin Manager already installed"
  else
    log "Installing Tmux Plugin Manager"
    mkdir -p "$(dirname "$tpm_home")"
    git clone https://github.com/tmux-plugins/tpm.git "$tpm_home"
  fi

  if ! command_exists tmux; then
    warn "tmux is not installed yet; skipping tmux plugin installation."
    return 0
  fi

  if [[ ! -f "$tmux_conf" ]]; then
    warn "tmux config is not linked at $tmux_conf; skipping tmux plugin installation."
    return 0
  fi

  log "Installing tmux plugins"
  "$tpm_home/bin/install_plugins"
}

stow_dotfiles() {
  command_exists stow || die "stow is not installed. Run without --skip-brew first, or install stow manually."

  log "Linking dotfiles with stow"
  (
    cd "$DOTFILES_DIR"
    stow .
  )
}

configure_atuin() {
  if ! command_exists atuin; then
    warn "atuin is not installed yet; skipping Atuin log directory setup."
    return 0
  fi

  log "Configuring Atuin log directory"
  mkdir -p "$HOME/.local/share/atuin/logs"
  atuin config set logs.dir "$HOME/.local/share/atuin/logs"

  if [[ -d "$HOME/.atuin" ]]; then
    warn "Leaving existing ~/.atuin in place. Remove it after confirming your Atuin data is migrated."
  fi
}

check_zsh_shell() {
  local zsh_path
  local current_shell

  if ! command_exists zsh; then
    warn "zsh is not installed or not on PATH. The dotfiles were linked, but zsh config will not be used yet."
    return 0
  fi

  zsh_path="$(command -v zsh)"
  current_shell="${SHELL:-unknown}"

  if [[ "$current_shell" == "$zsh_path" || "$current_shell" == */zsh ]]; then
    return 0
  fi

  warn "Your login shell is $current_shell, not zsh."
  warn "To switch after reviewing the path, run: chsh -s $zsh_path"
  warn "If chsh rejects it, add $zsh_path to /etc/shells first."
}

SKIP_BREW=0
SKIP_ZINIT=0
SKIP_TPM=0
SKIP_STOW=0
ASSUME_YES=0

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --skip-brew)
        SKIP_BREW=1
        ;;
      --skip-zinit)
        SKIP_ZINIT=1
        ;;
      --skip-tpm)
        SKIP_TPM=1
        ;;
      --skip-stow)
        SKIP_STOW=1
        ;;
      --yes)
        ASSUME_YES=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        usage
        die "Unknown option: $1"
        ;;
    esac
    shift
  done

  load_homebrew

  log "Bootstrapping dotfiles from $DOTFILES_DIR"
  log "Detected environment: $(detect_environment)"
  ensure_xdg_dirs

  if [[ "$SKIP_BREW" == "0" ]]; then
    install_brew_bundle
  else
    warn "Skipping Homebrew setup."
  fi

  if [[ "$SKIP_ZINIT" == "0" ]]; then
    install_zinit
  else
    warn "Skipping Zinit setup."
  fi

  if [[ "$SKIP_STOW" == "0" ]]; then
    stow_dotfiles
  else
    warn "Skipping stow."
  fi

  if [[ "$SKIP_TPM" == "0" ]]; then
    install_tpm
  else
    warn "Skipping Tmux Plugin Manager setup."
  fi

  configure_atuin
  check_zsh_shell

  log "Done. Open a new terminal session to load the zsh environment."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
