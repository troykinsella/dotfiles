#!/usr/bin/env bash

set -ex

cd $(dirname $0)

if [ "$(id -u)" = "0" ]; then
  echo "do not run as root"
  exit 1
fi

install() {
  sudo apt install -y $*
}

sudo apt-get update

install ntp
install stow

# shell
install fish
stow fish
sudo chsh -s /usr/bin/fish $(whoami)

# editor
install emacs-nox
stow emacs

# git
install git
stow git

# tmux
install tmux
stow tmux

# misc
install htop curl jq xclip

# window manager
stow xfce4
