# mac_dotfiles

Minimal macOS Zsh dotfiles.

## Structure

```text
~/.mac_dotfiles/
└── zsh/
    ├── env.zsh
    ├── shell.zsh
    └── aliases.zsh
```

## Clone

HTTPS:

```bash
git clone https://github.com/jonserr/mac_dotfiles.git ~/.mac_dotfiles
```

## Append the loader lines to `~/.zprofile` and `~/.zshrc`:

```bash
printf '%s\n' '[[ -f "$HOME/.mac_dotfiles/zsh/env.zsh" ]] && source "$HOME/.mac_dotfiles/zsh/env.zsh"' >> ~/.zprofile
```

```bash
printf '%s\n' \
'[[ -f "$HOME/.mac_dotfiles/zsh/shell.zsh" ]] && source "$HOME/.mac_dotfiles/zsh/shell.zsh"' \
'[[ -f "$HOME/.mac_dotfiles/zsh/aliases.zsh" ]] && source "$HOME/.mac_dotfiles/zsh/aliases.zsh"' >> ~/.zshrc
```

## Reload

```bash
source ~/.zprofile && source ~/.zshrc
```

## Files

- `zsh/env.zsh`  
  Homebrew, PATH, locale, editor, SDKMAN_DIR, Puppeteer path

- `zsh/shell.zsh`  
  interactive shell settings such as history, completion, colors, and prompt

- `zsh/aliases.zsh`  
  aliases only

## Notes

Optional machine-specific overrides can be placed in:

```text
~/.zprofile.local
~/.zshrc.local
```
