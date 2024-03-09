#!/usr/bin/env bash

set -euo pipefail


dotfiles_repo=git@github.com:troykinsella/dotfiles.git
distro=$(grep ^ID= /etc/os-release | cut -d= -f2)


bootstrap_apt() {
  sudo apt-get update -y
  sudo apt-get install -y curl git
}

bootstrap_arch() {
   sudo pacman -Syy
   sudo pacman -S --needed curl git
}

install_just() {
  mkdir -p ~/bin
  test -x ~/bin/just || curl -fSsL https://just.systems/install.sh | bash -s -- --to ~/bin
}

fetch_dotfiles() {
  if [[ -d ~/.dotfiles/.git ]]; then
    (
      cd ~/.dotfiles
      git pull
    )
  else
    git clone "$dotfiles_repo" ~/.dotfiles
  fi
}


# Main

case "$distro" in
  debian|ubuntu)
    bootstrap_apt
    ;;
  arch)
    bootstrap_arch
    ;;
  *)
    echo "unsupported distro: $distro" >&2
    exit 1
    ;;
esac

install_just
fetch_dotfiles

(
  cd ~/.dotfiles
  ~/bin/just basic
)
