#!/usr/bin/env bash

set -ex

test "$(id -u)" = "0" && { echo "do not run as root" >&2; exit 1; }
cd $(dirname $0)

# variables

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GO_VERSION=1.10.3
GO_PKG_SUM=fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035

JAVA_PKG=jdk-8u131-linux-x64.tar.gz
JAVA_PKG_URL=http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/$JAVA_PKG
JAVA_PKG_SUM=62b215bdfb48bace523723cdbb2157c665e6a25429c73828a32f00e587301236
JAVA_INSTALL=jdk1.8.0_131

BACON_VERSION=latest

PROTOC_VERSION=3.4.0
PROTOC_PKG_SUM=e4b51de1b75813e62d6ecdde582efa798586e09b5beaebfb866ae7c9eaadace4

LOCAL_PATH=/usr/local

# functions

install() {
  sudo apt install -y $*
}

check_sum() {
  local package_path=$1
  local package_sum=$2

  echo "$package_sum $package_path" | sha256sum -c || return 1

  return 0
}

needs_fetch() {
  local package_path=$1
  local package_sum=$2

  test -f $package_path || return 0
  check_sum $package_path $package_sum || return 0

  return 1
}

install_node() {
  export N_PREFIX=~/.n
  if [ ! -d $N_PREFIX ]; then
    local n_install_path=~/tmp/n-install
    mkdir -p ~/tmp
    curl -SL https://git.io/n-install > $n_install_path
    chmod +x $n_install_path
    $n_install_path -y -n stable
    rm $n_install_path
  fi
}

install_go() {
  (
    cd $LOCAL_PATH        
    local go_pkg=go${GO_VERSION}.linux-amd64.tar.gz
    local go_install=go${GO_VERSION}

    if [ ! -d $go_install ]; then
      if needs_fetch $go_pkg $GO_PKG_SUM; then
        sudo curl -SL https://storage.googleapis.com/golang/$go_pkg > $go_pkg
      fi
    fi

    check_sum $go_pkg $GO_PKG_SUM || exit 1
    sudo rm -rf go
    sudo rm -rf $go_install
    sudo tar zxf $go_pkg
    sudo mv go $go_install
    sudo ln -s $go_install go
    go/bin/go version || exit 1
  ) || exit $?
}

install_java() {
  (
    cd $LOCAL_PATH
    if [ ! -d $JAVA_INSTALL ]; then
      if needs_fetch $JAVA_PKG $JAVA_PKG_SUM; then
        sudo curl -jkSL -H "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_PKG_URL > $JAVA_PKG
      fi
    fi

    check_sum $JAVA_PKG $JAVA_PKG_SUM || exit 1
    sudo rm -rf java
    sudo rm -rf $JAVA_INSTALL
    sudo tar zxf $JAVA_PKG
    sudo ln -s $JAVA_INSTALL java
    java/bin/java -version || exit 1
  ) || exit $?
}

install_bacon() {
  (
    cd $LOCAL_PATH
    sudo killall bacon || true
    sudo $DIR/github_fetch_release.sh troykinsella bacon $BACON_VERSION bacon_linux_amd64 > bin/bacon  
    sudo chmod +x bin/bacon  
    bin/bacon -v || exit 1
  ) || exit $?
}

install_protoc() {
  (
    cd $LOCAL_PATH
    local protoc_pkg=protoc-$PROTOC_VERSION-linux-x86_64.zip

    if needs_fetch $protoc_pkg $PROTOC_PKG_SUM; then
      sudo $DIR/github_fetch_release.sh google protobuf $PROTOC_VERSION $protoc_pkg > $protoc_pkg
    fi

    check_sum $protoc_pkg $PROTOC_PKG_SUM || exit 1
    sudo unzip -o $protoc_pkg
    sudo chmod +x bin/protoc
    sudo rm readme.txt
    protoc --version || exit 1
  ) || exit $?
}

configure_encfs() {
  readonly ENC_DIR=~/.encrypted
  readonly DEC_DIR=~/.decrypted
  readonly ENCFS_MOUNT=~/bin/mount-encfs
  readonly ENCFS_UMOUNT=~/bin/umount-encfs
  readonly ENCFS_PASSWD=~/bin/encfs-passwd

  install encfs
  mkdir -p ~/bin
  mkdir -p $ENC_DIR
  mkdir -p $DEC_DIR

  cat <<EOF > $ENCFS_MOUNT
#!/usr/bin/env bash
if ! mount | grep "encfs on $DEC_DIR type fuse.encfs" > /dev/null; then
  encfs --standard $ENC_DIR $DEC_DIR
else
  echo Already mounted, stupid
fi
EOF

  cat <<EOF > $ENCFS_UMOUNT
#!/usr/bin/env bash
fusermount -u $DEC_DIR
EOF

  cat <<EOF > $ENCFS_PASSWD
#!/usr/bin/env bash
encfsctl passwd $ENC_DIR
EOF

  chmod +x $ENCFS_MOUNT $ENCFS_UMOUNT $ENCFS_PASSWD
  $ENCFS_MOUNT # run it
}

# main

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

# node
install_node

# git
install git
stow git

# misc tools
install htop curl jq xclip

# ansible
sudo pip install ansible

# go lang
install_go

# java
install_java

# bacon
install_bacon

# protoc
install_protoc

# encfs
configure_enfs
