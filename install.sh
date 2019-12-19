#!/bin/sh

LN=/bin/ln
DIR=$(dirname "$0")

$LN -hsv "$DIR/zsh/.zshrc" ~/
$LN -hsv "$DIR/zsh/.zprofile" ~/
$LN -hsv "$DIR/tmux/.tmux.conf" ~/
$LN -hsv "$DIR/vim/.vimrc" ~/
$LN -hsv "$DIR/vim" ~/.vim
$LN -hsv "$DIR/git/.gitignore_global" ~/
