# zsh/aliases.zsh

alias apptainer="$HOME/.local/bin/apptainer"

alias l='ls -lh'
alias la='ls -A'
alias ll='ls -lah'
alias cls='clear'
alias reload='source ~/.zprofile && source ~/.zshrc'
alias ip='ipconfig getifaddr en0 || ipconfig getifaddr en1'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
