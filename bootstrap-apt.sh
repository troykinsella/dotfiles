#!/usr/bin/env bash

set -eux

TARGET=${1:-all}

# Functions

install() {
    sudo apt-get install -y $*
}

essential() {
    sudo apt-get update -y
    install \
         curl \
	 htop \
         iftop \
         iotop \
	 jq \
	 stow \
	 xclip
}

# Targets

t_all() {
    t_ansible
    t_awscli
    t_bacon
    t_docker
    t_emacs
    t_encfs
    t_fish
    t_fonts
    t_git
    t_golang
    t_java
    t_nodejs
    t_protoc
    t_python
    t_ruby
    t_rust
    t_ssh
    t_tmux
    t_terraform
    t_urxvt
    t_vagrant
    t_virtualbox
    t_xfce4
}

t_ansible() {
    t_python
    sudo -H pip install --upgrade ansible
}

t_awscli() {
    t_python
    sudo -H pip3 install --upgrade awscli
}

t_bacon() {
    sudo install/bacon/install.sh
}

t_docker() {
    sudo apt-get remove -y docker.io
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo usermod -a -G docker $(whoami)
}

t_emacs() {
    install emacs-nox
    stow emacs
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
    sudo update-alternatives --set editor /usr/bin/emacs
}

t_encfs() {
    install/encfs/install.sh
}


t_fish() {
    install fish
    stow fish
    sudo chsh -s /usr/bin/fish $(whoami)

    # OSX compatibility for shared IntelliJ IDEA preferences
    # in which /usr/bin/env can't be used. Pff.
    sudo ln -s /usr/bin/fish /usr/local/bin/fish
}

t_fonts() {
    mkdir -p ~/.fonts
    cp fonts/**/*.ttf ~/.fonts
    fc-cache -f -v
}

t_git() {
    install git
    stow git
}

t_golang() {
    sudo install/golang/install.sh
}

t_java() {
    sudo install/java/install.sh
}

t_nodejs() {
    install/nodejs/install.sh
}

t_protoc() {
    sudo install/protoc/install.sh
}

t_python() {
    install \
	 python \
	 python-dev \
	 python-pip \
	 python3 \
	 python3-dev \
	 python3-pip

    sudo -H pip install --upgrade pip setuptools wheel
    sudo -H pip3 install --upgrade pip setuptools wheel
}

t_ruby() {
    install \
	ruby \
	ruby-dev
    stow gem
    sudo gem install \
        bundler \
        serverspec
}

t_rust() {
    if [ ! -x ~/.cargo/bin/rustup ]; then
        curl -fSsL https://sh.rustup.rs | sh
    else
        ~/.cargo/bin/rustup update stable
    fi

    ~/.cargo/bin/cargo install cargo-edit || true
}

t_ssh() {
    install openssh-server
}

t_tmux() {
    install tmux
    stow tmux
}

t_terraform() {
    sudo install/terraform/install.sh
}

t_urxvt() {
    install rxvt
    stow urxvt
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/urxvt 10
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
    xrdb ~/.Xresources
}

t_vagrant() {
    install vagrant
}

t_virtualbox() {
    install virtualbox
}

t_xfce4() {
    stow xfce4
}

# Main

essential
test "$TARGET" != "essential" && t_$TARGET
