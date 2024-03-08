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
    btop \
    direnv \
    fd-find \
    htop \
    iftop \
    iotop \
    jq \
    nethogs \
    ripgrep \
    stow
}

# Targets

t_all() {
  t_emacs
  t_git
  t_shell
}

t_emacs() {
  install \
    cmake \
    libtool-bin \
    shellcheck \
    emacs

  if [[ ! -d ~/.config/emacs/.git  ]]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install
    ~/.config/emacs/bin/doom doctor
  else
    ~/.config/emacs/bin/doom upgrade
    ~/.config/emacs/bin/doom sync
  fi

  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
  sudo update-alternatives --set editor /usr/bin/emacs

  stow emacs
}


t_git() {
  install git
  stow git
}

t_shell() {
  install \
    fish \
    neofetch \
    tmux \
    zoxide

  # When previously unstowed, and a config.fish file exists, move it
  # to allow the stow to succeed
  if [[ ! -L ~/.config/fish ]] && [[ -f ~/.config/fish/config.fish ]]; then
    mv ~/.config/fish/config.fish ~/.config/fish/config.fish.bak
  fi

  stow fish
  sudo chsh -s /usr/bin/fish $(whoami)

  curl -SsLf https://starship.rs/install.sh | sh
  stow starship

  stow tmux
}

# Main

sudo apt-get update -y
essential
test "$TARGET" != "essential" && t_$TARGET
