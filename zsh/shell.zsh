# zsh/shell.zsh

[[ -o interactive ]] || return 0

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# History
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=20000
export SAVEHIST=20000

# Completion
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# macOS CLI colors
export CLICOLOR=1
export LSCOLORS="ExFxCxDxBxegedabagacad"

# Simple prompt
PROMPT='%n@%m %~'$'\n''%# '

# Optional local-only overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
