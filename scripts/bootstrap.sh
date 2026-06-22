#!/bin/bash
# Bootstrap a macOS terminal setup using Oh My Zsh, Oh My Posh, iTerm2,
# JetBrains Mono Nerd Font, and the local dotfiles in this repo

set -o errexit
set -o nounset
set -o pipefail

readonly HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
readonly OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
readonly AUTOSUGGESTIONS_URL="https://github.com/zsh-users/zsh-autosuggestions"
readonly SYNTAX_HIGHLIGHTING_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly REPO_DIR
ZSHRC_SRC="${REPO_DIR}/zshrc"
readonly ZSHRC_SRC
OMP_THEME_SRC="${REPO_DIR}/oh-my-posh/jon-microverse-power.omp.json"
readonly OMP_THEME_SRC
readonly ITERM_PROFILE_SRC="${REPO_DIR}/iterm/custom_profile.json"

readonly OMP_THEME_DIR="${HOME}/.config/oh-my-posh/themes"
readonly OMP_THEME_DEST="${OMP_THEME_DIR}/jon-microverse-power.omp.json"
readonly ITERM_DYNAMIC_PROFILE_DIR="${HOME}/Library/Application Support/iTerm2/DynamicProfiles"
readonly ITERM_PROFILE_DEST="${ITERM_DYNAMIC_PROFILE_DIR}/jon-custom-profile.json"

log() { printf '%s\n' "$*"; }

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

command_exists() { command -v "$1" > /dev/null 2>&1; }

# Install a Homebrew formula only if it isn't already installed.
brew_install_formula() {
	local pkg="$1"
	if brew list --formula --versions "${pkg}" > /dev/null 2>&1; then
		log "  ${pkg} already installed; skipping."
	else
		log "  Installing ${pkg}..."
		brew install "${pkg}"
	fi
}

# Install a Homebrew cask only if it isn't already installed.
brew_install_cask() {
	local cask="$1"
	if brew list --cask --versions "${cask}" > /dev/null 2>&1; then
		log "  ${cask} already installed; skipping."
	else
		log "  Installing ${cask}..."
		brew install --cask "${cask}"
	fi
}

load_homebrew_env() {
	if [[ -x "/opt/homebrew/bin/brew" ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
		return
	fi

	if [[ -x "/usr/local/bin/brew" ]]; then
		eval "$(/usr/local/bin/brew shellenv)"
		return
	fi
}

install_homebrew() {
	if command_exists brew; then
		log "Homebrew already installed."
		return
	fi

	log "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL "${HOMEBREW_INSTALL_URL}")"
	load_homebrew_env

	if ! command_exists brew; then
		die "Homebrew was installed, but brew is still not available in PATH."
	fi
}

install_brew_packages() {
	log "Checking Homebrew packages and casks..."
	brew update
	brew_install_formula git
	brew_install_formula gh
	brew_install_formula oh-my-posh
	if [[ -d "/Applications/iTerm.app" ]]; then
		log "  iterm2 already installed; skipping."
	else
		brew_install_cask iterm2
	fi
	brew_install_cask font-jetbrains-mono-nerd-font
}

install_oh_my_zsh() {
	if [[ -d "${HOME}/.oh-my-zsh" ]]; then
		log "Oh My Zsh already installed."
		return
	fi

	log "Installing Oh My Zsh..."
	RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
		"$(curl -fsSL "${OH_MY_ZSH_INSTALL_URL}")" "" --unattended
}

clone_or_update_repo() {
	local repo_url="$1"
	local target_dir="$2"

	if [[ -d "${target_dir}/.git" ]]; then
		log "Updating ${target_dir}..."
		git -C "${target_dir}" pull --ff-only
		return
	fi

	log "Cloning ${repo_url}..."
	git clone "${repo_url}" "${target_dir}"
}

install_zsh_plugins() {
	local zsh_custom_dir
	zsh_custom_dir="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"

	mkdir -p "${zsh_custom_dir}/plugins"

	clone_or_update_repo \
		"${AUTOSUGGESTIONS_URL}" \
		"${zsh_custom_dir}/plugins/zsh-autosuggestions"

	clone_or_update_repo \
		"${SYNTAX_HIGHLIGHTING_URL}" \
		"${zsh_custom_dir}/plugins/zsh-syntax-highlighting"
}

backup_file() {
	local file_path="$1"
	local backup_path

	if [[ ! -e "${file_path}" && ! -L "${file_path}" ]]; then
		return
	fi

	backup_path="${file_path}.backup.$(date +%Y%m%d%H%M%S)"
	log "Backing up ${file_path} to ${backup_path}..."
	cp -p "${file_path}" "${backup_path}"
}

install_zshrc() {
	[[ -f "${ZSHRC_SRC}" ]] || die "Missing ${ZSHRC_SRC}."

	backup_file "${HOME}/.zshrc"
	cp -f "${ZSHRC_SRC}" "${HOME}/.zshrc"
	log "Installed ${HOME}/.zshrc."
}

install_oh_my_posh_theme() {
	[[ -f "${OMP_THEME_SRC}" ]] || die "Missing ${OMP_THEME_SRC}."

	mkdir -p "${OMP_THEME_DIR}"
	cp -f "${OMP_THEME_SRC}" "${OMP_THEME_DEST}"
	log "Installed ${OMP_THEME_DEST}."
}

install_iterm_profile() {
	if [[ ! -f "${ITERM_PROFILE_SRC}" ]]; then
		log "No iTerm profile found at ${ITERM_PROFILE_SRC}; skipping."
		return
	fi

	mkdir -p "${ITERM_DYNAMIC_PROFILE_DIR}"

	if ! grep -q '"Profiles"[[:space:]]*:' "${ITERM_PROFILE_SRC}"; then
		log "WARNING: iTerm dynamic profiles usually need a top-level Profiles array."
		log "WARNING: Copied the file anyway, but iTerm may not load it."
	fi

	cp -f "${ITERM_PROFILE_SRC}" "${ITERM_PROFILE_DEST}"
	log "Installed ${ITERM_PROFILE_DEST}."
}

silence_login_banner() {
	touch "${HOME}/.hushlogin"
	log "Created ${HOME}/.hushlogin to silence the macOS Last login banner."
}

main() {
	load_homebrew_env
	install_homebrew
	load_homebrew_env
	install_brew_packages
	install_oh_my_zsh
	install_zsh_plugins
	install_oh_my_posh_theme
	install_iterm_profile
	install_zshrc
	silence_login_banner

	log "Done."
	log "Open a new iTerm window or run: exec zsh"
}

main "$@"
