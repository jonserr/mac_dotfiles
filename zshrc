# Path -------------------------------------------------------------------------
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

# Oh My Zsh --------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# History ----------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=5000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Docker completions -----------------------------------------------------------
if [[ -d "$HOME/.docker/completions" ]]; then
	fpath=("$HOME/.docker/completions" $fpath)
fi

# Plugins ----------------------------------------------------------------------
plugins=(
	git
	gh
	macos
	brew
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Autosuggestions --------------------------------------------------------------
if [[ -n "${widgets[autosuggest-accept]}" ]]; then
	bindkey '^[[C' autosuggest-accept
fi

# Aliases ----------------------------------------------------------------------
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias mkdir='mkdir -p'

# Git aliases ------------------------------------------------------------------
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gl='git log --oneline --graph --decorate --all'

# GitHub CLI aliases -----------------------------------------------------------
alias ghv='gh repo view --web'
alias gha='gh auth status'

# Python -----------------------------------------------------------------------
alias python='python3'
alias pip='python3 -m pip'

# Useful functions -------------------------------------------------------------
mkcd() {
	if mkdir -p "$1" && cd "$1"; then
		return 0
	else
		echo "Failed to create and navigate to directory: $1"
		return 1
	fi
}

extract() {
	if [[ -f "$1" ]]; then
		case "$1" in
			*.tar.bz2) tar xjf "$1" ;;
			*.tar.gz) tar xzf "$1" ;;
			*.bz2) bunzip2 "$1" ;;
			*.rar) unrar x "$1" ;;
			*.gz) gunzip "$1" ;;
			*.tar) tar xf "$1" ;;
			*.tbz2) tar xjf "$1" ;;
			*.tgz) tar xzf "$1" ;;
			*.zip) unzip "$1" ;;
			*.7z) 7z x "$1" ;;
			*) echo "Cannot extract: $1" ;;
		esac
	else
		echo "File not found: $1"
	fi
}

# NVM --------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
	source "$NVM_DIR/nvm.sh"
fi

if [[ -s "$NVM_DIR/bash_completion" ]]; then
	source "$NVM_DIR/bash_completion"
fi

# Homebrew ---------------------------------------------------------------------
export HOMEBREW_DEVELOPER=1
export HOMEBREW_SKIP_OR_LATER_MAX_OS_CHECK=1

# Apptainer through Lima -------------------------------------------------------
export APPTAINER_LIMA_VM="${APPTAINER_LIMA_VM:-apptainer}"

export PATH="$HOME/.local/bin:$PATH"
alias apptainer="$HOME/.local/bin/apptainer"
singularity() { apptainer "$@"; }

# Oh My Posh -------------------------------------------------------------------
eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/themes/jon-microverse-power.omp.json")"
