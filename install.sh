#!/usr/bin/env bash
# Author : nimula+github@gmail.com

install_zsh() {
  # Test to see if zshell is installed.
  if [ -z "$(command -v zsh)" ]; then
    # If zsh isn't installed, get the platform of the current machine and
    # install zsh with the appropriate package manager.
    platform=$(uname);
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get install zsh
      fi
    elif [[ $platform == 'Darwin' ]]; then
      brew install zsh
    fi
  fi
  # Set the default shell to zsh if it isn't currently set to zsh
  if [[ ! "$SHELL" == "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)"
  fi
  # Install zim if it isn't already present
  if [[ ! -d $HOME/.zim/ ]]; then
    echo "Install zim"
    curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
  fi
}

install_nerd_font() {
  platform=$(uname);
  if [[ $platform == 'Darwin' ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-sauce-code-pro-nerd-font
  fi
}

install_tmux() {
  # Test to see if tmux is installed.
  if [ -z "$(command -v tmux)" ]; then
    # If tmux isn't installed, get the platform of the current machine and
    # install tmux with the appropriate package manager.
    platform=$(uname);
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install tmux
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get install tmux
      fi
    elif [[ $platform == 'Darwin' ]]; then
      brew install --cask iterm2
    fi
  fi
  # Clone Tmux Plugin Manager if it isn't already present
  if [[ ! -d $HOME/.tmux/plugins/tpm/ ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

install_rsubl() {
	# Test to see if rmate is installed.
  if [ -z "$(command -v rsubl)" ]; then
    sudo curl https://raw.github.com/aurora/rmate/master/rmate -fsSL \
      -o /usr/local/bin/rsubl
  	sudo chmod a+x /usr/local/bin/rsubl
	fi
}

# Install zsh (if not available) and zim.
install_zsh
# Install sauce code pro nerd font
install_nerd_font
# Install tmux (if not available) and tmux plugin manager
install_tmux
# Install rmate as rsubl
install_rsubl

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Symlink zsh dotfiles.
ln -fnsv "$DIR/zsh/.zshrc" "$HOME"
ln -fnsv "$DIR/zsh/.zprofile" "$HOME"
ln -fnsv "$DIR/zsh/.zimrc" "$HOME"
ln -fnsv "$DIR/zsh/.p10k.zsh" "$HOME"

# Symlink other dotfiles.
ln -fnsv "$DIR/tmux/.tmux.conf" "$HOME"
ln -fnsv "$DIR/vim/.vimrc" "$HOME"
ln -fnsv "$DIR/vim" "$HOME/.vim"
ln -fnsv "$DIR/git/.gitignore.global" "$HOME"

# Link static gitconfig.
git config --global include.path "$DIR/git/.gitconfig.static"

# Update zim module
zsh ~/.zim/zimfw.zsh install
