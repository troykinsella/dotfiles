#!/usr/bin/env bash

set -euxo pipefail

TARGET=${1:-all}

ASDF_VERSION=0.10.0

# Functions

install() {
  sudo apt-get install -y $*
}

essential() {
  install \
    build-essential \
    curl \
    net-tools \
    whois \
    xclip
}

# Targets

t_all() {
  t_asdf
  t_docker
  t_fonts
  t_rust
  t_ssh
  t_xfce4
}

t_asdf() {
  if ! [[ -d ~/.asdf ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "v${ASDF_VERSION}"
  fi
}

t_docker() {
  sudo apt-get remove -y docker.io
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-get update
  sudo apt-get install -y docker
}

t_fonts() {
  mkdir -p ~/.fonts
  cp fonts/**/*.ttf ~/.fonts
  fc-cache -f -v
}

t_rust() {
  install libssl-dev

  if [[ ! -x ~/.cargo/bin/rustup ]]; then
    curl -fSsL https://sh.rustup.rs | sh
  else
    ~/.cargo/bin/rustup update stable
  fi

  ~/.cargo/bin/cargo install cargo-edit || true
}

t_ssh() {
  install openssh-server
}

t_xfce4() {
  stow xfce4
}

# Main

sudo apt-get update -y
essential
test "$TARGET" != "essential" && t_$TARGET
