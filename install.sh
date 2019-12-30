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
  # Clone Oh My Zsh if it isn't already present
  if [[ ! -d $HOME/.oh-my-zsh/ ]]; then
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"
  fi
  # Clone Powerlevel10k if it isn't already present.
  if [[ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
    git clone https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
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
      brew install tmux
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
  	sudo wget -O /usr/local/bin/rsubl \
    	https://raw.github.com/aurora/rmate/master/rmate
  	sudo chmod a+x /usr/local/bin/rsubl
	fi
}

# Install zsh (if not available) and oh-my-zsh and p10k.
install_zsh
# Install tmux (if not available) and tmux plugin manager
install_tmux
# Install rmate as rsubl
install_rsubl

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Symlink the dotfiles.
ln -fnsv "$DIR/bash/.bashrc" "$HOME/"
ln -fnsv "$DIR/bash/.profile" "$HOME/"
ln -fnsv "$DIR/zsh/.zshrc" "$HOME/"
ln -fnsv "$DIR/zsh/.zprofile" "$HOME/"
ln -fnsv "$DIR/tmux/.tmux.conf" "$HOME/"
ln -fnsv "$DIR/vim/.vimrc" "$HOME/"
ln -fnsv "$DIR/vim" "$HOME/.vim"
ln -fnsv "$DIR/git/.gitignore.global" "$HOME/"

# Link static gitconfig.
git config --global include.path "$DIR/git/.gitconfig.static"
