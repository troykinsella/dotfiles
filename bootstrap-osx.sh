#!/usr/bin/env bash

set -eux

TARGET=${1:-all}

# Funtions

install() { # Lifted from vito/dotfiles
    local name=$(basename $1)
    if brew list | grep "\\<$name\\>"; then
        brew outdated "$name" || brew upgrade $*
    else
        brew install $*
    fi
}

install_cask() {
    for x in "$@"; do
        if ! brew cask list | grep "\\<$x\\>"; then
            brew cask install "$x"
        fi
    done
}

essential() {
    install ruby
    
    which brew > /dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap caskroom/cask

    install \
        coreutils \
	htop \
	jq \
	stow

   # TODO link gsha256sum, etc. in loop
}

# Targets

t_all() {
    t_ansible
    t_awscli
    t_chrome
    t_docker
    t_emacs
    t_fish
    t_git
    t_golang
    t_java
    t_python
    t_slack
    t_vagrant
    t_virtualbox
}

t_ansible() {
    t_python
    sudo -H pip install --upgrade ansible 
}

t_awscli() {
    t_python
    sudo -H pip3 install --upgrade awscli
}

t_chrome() {
    install_cask google-chrome
}

t_docker() {
    install_cask docker
    install \
        docker-compose \
        docker-machine \
        ctop
}

t_emacs() {
    install emacs
    stow emacs
}

t_fish() {
    install fish
    grep "$(which fish)" /etc/shells > /dev/null || sudo sh -c "echo $(which fish) >> /etc/shells"
    finger $USER | grep "$(which fish)" > /dev/null || sudo chsh -s "$(which fish)" $(whoami)
    stow fish
}

t_git() {
    install git
    stow git
}

t_golang() {
    sudo install/golang/install.sh
}

t_iterm2() {
     install_cask iterm2
}

t_java() {
    install java8
}

t_python() {
    install \
        python@2 \
        python@3
    sudo -H pip install --upgrade pip setuptools wheel
    sudo -H pip3 install --upgrade pip setuptools wheel
}

t_ruby() {
    # installed in essential
    stow gem

    sudo gem install serverspec
}

t_slack() {
    install_cask slack
}

t_vagrant() {
    install_cask vagrant
}

t_virtualbox() {
    install_cask virtualbox
}

# Main

essential
test "$TARGET" != "essential" && t_$TARGET
