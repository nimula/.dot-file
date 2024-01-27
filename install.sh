#!/usr/bin/env bash
# Author : nimula+github@gmail.com
#

# Get the platform of the current machine.
platform=$(uname);

function install_zsh() {
  # Test to see if zshell is installed.
  if [[ -z "$(command -v zsh)" ]]; then
    # If zsh isn't installed, get the platform of the current machine and
    # install zsh with the appropriate package manager.
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
      elif [[ -f /etc/debian_version ]]; then
        sudo apt-get install zsh
      fi
    elif [[ $platform == 'Darwin' ]]; then
      brew install zsh
    fi
  fi

  if [[ $platform == 'Linux' || $platform == 'Darwin' ]]; then
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! "$SHELL" == "$(command -v zsh)" ]]; then
      chsh -s "$(command -v zsh)"
    fi
  fi

  # Upgrading Bash on macOS
  if [[ $platform == 'Darwin' ]]; then
      brew install bash
  fi
  # Install zim if it isn't already present
  if [[ ! -d "$HOME/.zim/" ]]; then
    echo "Install zim"
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
  fi
}

function install_nerd_font() {
  if [[ $platform == 'Darwin' ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-sauce-code-pro-nerd-font \
    font-noto-sans font-noto-sans-cjk font-noto-serif font-noto-serif-cjk
  fi
}

function install_tmux() {
  if [[ $platform == 'Linux' ]]; then
    if [[ -z "$(command -v tmux)" ]]; then
      # If tmux isn't installed, install it with the appropriate package manager.
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install tmux
      elif [[ -f /etc/debian_version ]]; then
        sudo apt-get install tmux
      fi
    fi
    # Clone Tmux Plugin Manager if it isn't already present
    if [[ ! -d "$HOME/.tmux/plugins/tpm/" ]]; then
      git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  fi
}

function install_rsubl() {
	# Test to see if rmate is installed.
  if [[ -z "$(command -v rsubl)" ]]; then
    DIR="/usr/local/bin"
    SUDO="sudo"
    # If '/usr/local/bin' is not available, use '.local/bin' instead.
    if [[ ! -d "$DIR" ]]; then
      DIR="$HOME/.local/bin"
      SUDO=""
    fi

    $SUDO curl https://raw.github.com/aurora/rmate/master/rmate -fsSL \
      -o "$DIR/rsubl"
  	$SUDO chmod a+x "$DIR/rsubl"
	fi
}

function set_skip_global_compinit() {
  if ! grep -q "skip_global_compinit=1" "$HOME/.zshenv"; then
    echo "" >> "$HOME/.zshenv"
    echo "skip_global_compinit=1" >> "$HOME/.zshenv"
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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Symlink zsh dotfiles.
ln -fnsv "$DIR/zsh/.zshrc" "$HOME"
ln -fnsv "$DIR/zsh/.zprofile" "$HOME"
ln -fnsv "$DIR/zsh/.zimrc" "$HOME"
ln -fnsv "$DIR/zsh/.p10k.zsh" "$HOME"

# Symlink other dotfiles.
ln -fnsv "$DIR/vim/.vimrc" "$HOME"
ln -fnsv "$DIR/vim" "$HOME/.vim"
ln -fnsv "$DIR/git/.gitignore.global" "$HOME"
if [[ $platform == 'Linux' ]]; then
 ln -fnsv "$DIR/tmux/.tmux.conf" "$HOME"
fi

# Link static gitconfig.
git config --global include.path "$DIR/git/.gitconfig.static"

# Update zim module.
zsh ~/.zim/zimfw.zsh install
zsh ~/.zim/zimfw.zsh upgrade

set_skip_global_compinit
