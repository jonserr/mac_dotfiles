# zsh/env.zsh

# Homebrew (try arm Apple Silicon first, then Intel)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Basic environment
export LANG="en_US.UTF-8"
export EDITOR="nano"
export VISUAL="$EDITOR"

# User PATH entries
typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)
export PATH

# App environment
export SDKMAN_DIR="$HOME/.sdkman"
export PUPPETEER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Optional local-only overrides
[[ -f "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
