
all: apt bacon docker emacs encfs essential fish git golang java nodejs protoc python ruby terraform tmux xfce4

ansible: python
	sudo pip install ansible

apt:
	sudo apt update -y

bacon: essential
	sudo install/bacon/install.sh

docker: essential
	sudo apt install -y docker.io
	sudo usermod -a -G docker $$(whoami)

emacs: essential
	sudo apt install -y emacs-nox
	stow emacs
	sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
	sudo update-alternatives --set editor /usr/bin/emacs

encfs: essential
	install/encfs/install.sh

essential: apt
	sudo apt install -y \
	  curl \
	  htop \
	  jq \
	  stow \
	  xclip

fish: essential
	sudo apt install -y fish
	stow fish
	sudo chsh -s /usr/bin/fish $$(whoami)

git: essential
	sudo apt install -y git
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
	sudo apt install -y \
	  python \
	  python-dev \
	  python-pip \
	  python3 \
	  python3-dev \
	  python3-pip

ruby: essential
	sudo apt install -y \
	  ruby \
	  ruby-dev
	stow gem

tmux: essential
	sudo apt install -y tmux
	stow tmux

terraform: essential
	sudo install/terraform/install.sh

xfce4: essential
	stow xfce4
