#!/usr/bin/env bash

set -ex

test "$(id -u)" = "0" && { echo "do not run as root"; exit 1; }
cd $(dirname $0)

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

# window manager
stow xfce4

# terminal
install rxvt-unicode-256color
stow urxvt

# tmux
install tmux
stow tmux

# editor
install emacs-nox
stow emacs
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
sudo update-alternatives --set editor /usr/bin/emacs

# python
install python-dev python-pip python3-dev python3-pip

# ruby
install ruby
stow gem

# git
install git
stow git

# misc
install htop curl jq xclip
