#!/usr/bin/env bash

set -euxo pipefail

TARGET=${1:-all}

# Functions

install() {
  sudo apt-get install -y $*
}

essential() {
  install \
    curl \
    htop \
    iftop \
    iotop \
    jq \
    nethogs \
    stow
}

# Targets

t_all() {
  t_emacs
  t_fish
  t_git
  t_tmux
}

t_emacs() {
  install emacs-nox
  stow emacs
  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
  sudo update-alternatives --set editor /usr/bin/emacs
}

t_fish() {
  install fish
  stow fish
  sudo chsh -s /usr/bin/fish $(whoami)
}

t_git() {
  install git
  stow git
}

t_tmux() {
  install tmux
  stow tmux
}

# Main

sudo apt-get update -y
essential
test "$TARGET" != "essential" && t_$TARGET
