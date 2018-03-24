#!/usr/bin/env bash

set -ex

test "$(id -u)" = "0" && { echo "do not run as root" >&2; exit 1; }
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

# node
export N_PREFIX=~/.n
if [ ! -d $N_PREFIX ]; then
  mkdir -p ~/tmp
  curl -SL https://git.io/n-install > ~/tmp/n-install
  chmod +x ~/tmp/n-install
  ~/tmp/n-install -y -n stable
fi

# git
install git
stow git

# misc
install htop curl jq xclip

# encfs
readonly ENC_DIR=~/.encrypted
readonly DEC_DIR=~/.decrypted
readonly ENCFS_MOUNT=~/bin/mount-encfs
readonly ENCFS_UMOUNT=~/bin/umount-encfs

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

chmod +x $ENCFS_MOUNT $ENCFS_UMOUNT
$ENCFS_MOUNT # run it
