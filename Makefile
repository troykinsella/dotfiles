
all: apt-get bacon docker emacs encfs essential fish git golang java nodejs protoc python ruby ssh terraform tmux urxvt xfce4

ansible: python
	sudo pip install ansible

apt-get:
	sudo apt-get update -y

bacon: essential
	sudo install/bacon/install.sh

docker: essential
	sudo apt-get install -y docker.io
	sudo usermod -a -G docker $$(whoami)

emacs: essential
	sudo apt-get install -y emacs-nox
	stow emacs
	sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
	sudo update-alternatives --set editor /usr/bin/emacs

encfs: essential
	install/encfs/install.sh

essential: apt-get
	sudo apt-get install -y \
	  curl \
	  htop \
	  jq \
	  stow \
	  xclip

fish: essential
	sudo apt-get install -y fish
	stow fish
	sudo chsh -s /usr/bin/fish $$(whoami)

git: essential
	sudo apt-get install -y git
	stow git

golang: essential
	sudo install/golang/install.sh

java: essential
	sudo install/java/install.sh

nodejs: essential
	install/nodejs/install.sh

protoc: essential
	sudo install/protoc/install.sh

python: essential
	sudo apt-get install -y \
	  python \
	  python-dev \
	  python-pip \
	  python3 \
	  python3-dev \
	  python3-pip

ruby: essential
	sudo apt-get install -y \
	  ruby \
	  ruby-dev
	stow gem

ssh:
	sudo apt-get install -y openssh-server

tmux: essential
	sudo apt-get install -y tmux
	stow tmux

terraform: essential
	sudo install/terraform/install.sh

urxvt: essential
	sudo apt-get install -y rxvt
	stow urxvt
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/urxvt 10
	sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
	xrdb ~/.Xresources

xfce4: essential
	stow xfce4
