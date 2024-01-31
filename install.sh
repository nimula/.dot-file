#!/usr/bin/env bash
# Author : nimula+github@gmail.com
#
set -e

# Get the platform of the current machine.
PLATFORM=$(uname);
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
NL="\n"
if [[ ${PLATFORM} -eq "Darwin" ]]; then
    NL=$'\\\n'
fi

function install_zsh() {
  # Test to see if zshell is installed.
  if [[ -z "$(command -v zsh)" ]]; then
    # If zsh isn't installed, get the platform of the current machine and
    # install zsh with the appropriate package manager.
    if [[ ${PLATFORM} -eq 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
      elif [[ -f /etc/debian_version ]]; then
        sudo apt-get install zsh
      fi
    elif [[ ${PLATFORM} -eq 'Darwin' ]]; then
      brew install zsh
    fi
  fi

  if [[ ${PLATFORM} -eq 'Linux' || ${PLATFORM} -eq 'Darwin' ]]; then
    # Set the default shell to zsh if it isn't currently set to zsh.
    if [[ "$SHELL" -ne "$(command -v zsh)" ]]; then
      chsh -s "$(command -v zsh)"
    fi
  fi

  # Upgrading Bash on macOS
  if [[ ${PLATFORM} -eq 'Darwin' ]]; then
      brew install bash
  fi
  # Install zim if it isn't already present
  if [[ ! -d "${HOME}/.zim/" ]]; then
    echo "Install zim"
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
  fi
}

function install_nerd_font() {
  if [[ ${PLATFORM} -eq 'Darwin' ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-sauce-code-pro-nerd-font \
    font-noto-sans font-noto-sans-cjk font-noto-serif font-noto-serif-cjk
  fi
}

function install_tmux() {
  if [[ ${PLATFORM} -eq 'Linux' ]]; then
    if [[ -z "$(command -v tmux)" ]]; then
      # If tmux isn't installed, install it with the appropriate package manager.
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install tmux
      elif [[ -f /etc/debian_version ]]; then
        sudo apt-get install tmux
      fi
    fi
    # Clone Tmux Plugin Manager if it isn't already present.
    if [[ ! -d "${HOME}/.tmux/plugins/tpm/" ]]; then
      git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
    fi
  fi
}

function install_rsubl() {
	# Test to see if rsubl is installed.
  if [[ -z "$(command -v rsubl)" ]]; then
    DEST="/usr/local/bin"
    SUDO="sudo"
    # If '/usr/local/bin' is not available, use '.local/bin' instead.
    if [[ ! -d ${DEST} ]]; then
      DEST="${HOME}/.local/bin"
      SUDO=""
    fi

    $SUDO curl https://raw.github.com/aurora/rmate/master/rmate -fsSL \
      -o "${DEST}/rsubl"
  	$SUDO chmod a+x "${DEST}/rsubl"
	fi
}

function insert_ssh_config() {
  if ! grep -q "Include ${CURR_DIR}/ssh/config" "${HOME}/.ssh/config"; then
    sed -i -- "1 i\\
Include ${CURR_DIR}/ssh/config${NL}
" "${HOME}/.ssh/config"
  fi
}

function set_skip_global_compinit() {
  if ! grep -q "skip_global_compinit=1" "${HOME}/.zshenv"; then
    sed -i -- "$ a\\
${NL}skip_global_compinit=1
" "${HOME}/.zshenv"
  fi
}

# Install zsh (if not available) and zim.
install_zsh
# Install sauce code pro nerd font and noto fonts.
install_nerd_font
# Install tmux (if not available) and tmux plugin manager.
install_tmux
# Install rmate as rsubl.
install_rsubl
# Include preset ssh configurations.
insert_ssh_config

# Symlink zsh dotfiles.
ln -fnsv "${CURR_DIR}/zsh/.zshrc" "${HOME}"
ln -fnsv "${CURR_DIR}/zsh/.zprofile" "${HOME}"
ln -fnsv "${CURR_DIR}/zsh/.zimrc" "${HOME}"
ln -fnsv "${CURR_DIR}/zsh/.p10k.zsh" "${HOME}"

# Symlink other dotfiles.
ln -fnsv "${CURR_DIR}/vim/.vimrc" "${HOME}"
ln -fnsv "${CURR_DIR}/vim" "${HOME}/.vim"
ln -fnsv "${CURR_DIR}/git/.gitignore.global" "${HOME}"
if [[ ${PLATFORM} -eq 'Linux' ]]; then
 ln -fnsv "${CURR_DIR}/tmux/.tmux.conf" "${HOME}"
fi

# Link static gitconfig.
git config --global include.path "${CURR_DIR}/git/.gitconfig.static"

# Update zim module.
zsh ~/.zim/zimfw.zsh install
zsh ~/.zim/zimfw.zsh upgrade

set_skip_global_compinit
