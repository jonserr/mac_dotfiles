# mac_dotfiles

Personal macOS terminal bootstrap for:

- Homebrew
- iTerm2
- Oh My Zsh
- Oh My Posh (custom theme)
- JetBrains Mono Nerd Font
- zsh-autosuggestions
- zsh-syntax-highlighting
- Custom iTerm Dynamic Profile

Anything already installed (Homebrew, each formula/cask, Oh My Zsh, the zsh plugins) is detected and skipped, so re-running is safe.

## Repo layout

```text
mac_dotfiles/
├── Makefile
├── README.md
├── zshrc
├── oh-my-posh/
│   └── jon-microverse-power.omp.json
├── iterm/
│   └── custom_profile.json
└── scripts/
    └── bootstrap.sh
```

## Install on a new Mac

Install Apple Command Line Tools first (git may need them):

```zsh
xcode-select --install
```

Then clone and install:

```zsh
mkdir -p "$HOME/Documents/Development" && cd "$HOME/Documents/Development" \
  && git clone https://github.com/jonserr/mac_dotfiles.git mac_dotfiles \
  && cd mac_dotfiles && make install
```

After the script finishes, open iTerm2, select the **Jon Custom** dynamic
profile, and confirm the font is: `JetBrainsMono Nerd Font` and make sure to enable use ligatures and also set as default for new window.

iTerm2 picks up the profile automatically from the Dynamic Profiles folder
(`~/Library/Application Support/iTerm2/DynamicProfiles`).
Restart iTerm2 if it does not appear immediately.

## What `make install` does

`scripts/bootstrap.sh`:

1. Installs Homebrew if missing (supports `/opt/homebrew` on Apple Silicon and
   `/usr/local` on Intel).
2. Installs `git`, `gh`, `oh-my-posh`, the `iterm2` cask, and the
   `font-jetbrains-mono-nerd-font` cask — skipping any already installed.
3. Installs Oh My Zsh unattended (only if `~/.oh-my-zsh` is absent).
4. Clones/updates `zsh-autosuggestions` and `zsh-syntax-highlighting`.
5. Copies the Oh My Posh theme to `~/.config/oh-my-posh/themes/`.
6. Copies the iTerm Dynamic Profile into the iTerm DynamicProfiles folder.
7. Backs up any existing `~/.zshrc`, then installs this repo's `zshrc`.
8. Creates `~/.hushlogin` to silence the macOS "Last login" banner.

## The iTerm profile

`iterm/custom_profile.json` is a valid iTerm2 **Dynamic Profile** — a top-level
`Profiles` array of profile objects, each with a `Guid` and `Name`:

```json
{
  "Profiles": [
    { "Guid": "jon-custom-profile-0001", "Name": "Jon Custom" }
  ]
}
```

The bundled file is a starting point (JetBrains Mono Nerd Font, dark
background). To use your own exported settings, replace it with your profile —
but keep the top-level `Profiles` wrapper, or iTerm won't auto-load it. Verify
before pushing:

```zsh
grep -n '"Profiles"' iterm/custom_profile.json
```

If that prints nothing, the file is a raw profile object rather than a Dynamic
Profile wrapper, and iTerm will not load it from the DynamicProfiles directory.
