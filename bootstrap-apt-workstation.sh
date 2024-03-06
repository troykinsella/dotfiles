#!/usr/bin/env bash

set -euxo pipefail

TARGET=${1:-all}

ASDF_VERSION=0.10.0

# Functions

install() {
  sudo apt install -y $*
}

essential() {
  install \
    build-essential \
    curl \
    net-tools \
    pkg-config \
    snapd \
    software-properties-common \
    whois \
    xclip
}

# Targets

t_all() {
  t_ansible
  t_asdf
  t_docker
  t_doom_emacs
  t_fonts
  t_just
  t_packages
  t_python
  t_rust
  t_snaps
  t_xfce4
}

t_ansible() {
  which pipx || t_python
  pipx install --include-deps ansible
}

t_asdf() {
  if ! [[ -d ~/.asdf ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "v${ASDF_VERSION}"
  fi
}

t_docker() {
  sudo apt-get remove -y docker.io docker-ce
  install podman
}

t_doom_emacs() {
  install \
    libtool-bin \
    fd-find \
    ripgrep \
    shellcheck

  if [[ ! -d ~/.config/emacs ]]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install
    ~/.config/emacs/bin/doom doctor
  fi

}

t_fonts() {
  mkdir -p ~/.fonts
  cp fonts/**/*.ttf ~/.fonts
  fc-cache -f -v
}

t_just() {
  test -x ~/bin/just && return
  curl -fSsL https://just.systems/install.sh | bash -s -- --to ~/bin
}

t_packages() {
  install \
    audacity \
    gimp \
    gkrellm \
    gkrelltop \
    greybird-gtk-theme \
    keepassxc \
    inkscape \
    lmms \
    obs-studio \
    openssh-server \
    peek \
    remmina \
    thunderbird \
    vlc
}

t_python() {
  install \
    python3 \
    pipx
}

t_rust() {
  install libssl-dev

  if [[ ! -x ~/.cargo/bin/rustup ]]; then
    curl -fSsL https://sh.rustup.rs | sh
  else
    ~/.cargo/bin/rustup update stable
  fi

  rustup component add rust-src
  rustup component add rust-analyzer

  rustup target add wasm32-unknown-unknown

  ~/.cargo/bin/cargo install cargo-edit || true
}

t_snaps() {
  local snaps="core brave xmind"
  for s in $snaps; do
    sudo snap install $s
  done
}

t_xfce4() {
  stow xfce4
}

# Main

sudo apt-get update -y
essential
test "$TARGET" != "essential" && t_$TARGET
