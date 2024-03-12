# This is a justfile. See https://github.com/casey/just

set export

ASDF_VERSION := "0.14.0"

distro := `grep ^ID= /etc/os-release | cut -d= -f2`


yay: git
  #!/usr/bin/env bash
  if [[ "{{distro}}" == "arch" ]]; then
    if ! which yay > /dev/null; then
      sudo pacman -S --needed base-devel
      git clone https://aur.archlinux.org/yay.git .yay_tmp
      (
        cd .yay_tmp
        makepgk -si
      )
      rm -rf .yay_tmp
    fi
  fi


package-cache-update:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get update -y
      ;;
    arch)
      sudo pacman -Syy
      ;;
    *)
      echo "unsupported distro: {{distro}}" >&2
      exit 1
      ;;
  esac


essential: package-cache-update
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y \
        btop \
        curl \
        direnv \
        fd-find \
        htop \
        iftop \
        iotop \
        jq \
        nethogs \
        ripgrep \
        unzip \
        stow
      ;;
    arch)
      sudo pacman -S --needed \
        btop \
        curl \
        direnv \
        fd \
        htop \
        iftop \
        iotop \
        jq \
        less \
        nethogs \
        ripgrep \
        unzip \
        stow
      ;;
  esac


home-dirs:
  mkdir -p ~/bin
  mkdir -p ~/dl
  mkdir -p ~/documents
  mkdir -p ~/pictures
  mkdir -p ~/tmp
  mkdir -p ~/videos
  mkdir -p ~/wallpapers


git:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y git
      ;;
    arch)
      sudo pacman -S --needed git
      ;;
  esac
  stow git


emacs:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y \
        cmake \
        libtool-bin \
        shellcheck \
        emacs

      sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
      sudo update-alternatives --set editor /usr/bin/emacs
      ;;
    arch)
      sudo pacman -S --needed \
        cmake \
        libtool \
        shellcheck \
        emacs
      ;;
  esac

  stow emacs

  if [[ ! -d ~/.config/emacs/.git  ]]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install
  else
    ~/.config/emacs/bin/doom upgrade
  fi

  ~/.config/emacs/bin/doom sync


shell:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y \
        fish \
        neofetch \
        zoxide

      if ! which starship; then
        curl -SsLf https://starship.rs/install.sh | sh
      fi
      ;;
    arch)
      sudo pacman -S --needed \
        fish \
        neofetch \
        starship \
        zoxide
      ;;
  esac

  # When previously unstowed, and a config.fish file exists, move it
  # to allow the stow to succeed
  if [[ ! -L ~/.config/fish ]] && [[ -f ~/.config/fish/config.fish ]]; then
    mv ~/.config/fish/config.fish ~/.config/fish/config.fish.bak
  fi

  sudo chsh -s /usr/bin/fish $(whoami)

  stow fish
  stow starship


rust:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y libssl-dev
      if [[ ! -x ~/.cargo/bin/rustup ]]; then
        curl -fSsL https://sh.rustup.rs | sh
      fi
      ;;
    arch)
      sudo pacman -S --needed rustup
      ;;
  esac

  ~/.cargo/bin/rustup update stable

  rustup component add rust-src
  rustup component add rust-analyzer

  rustup target add wasm32-unknown-unknown

  ~/.cargo/bin/cargo install cargo-edit || true


terminal: fonts rust python
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y \
        cmake \
        pkg-config \
        libfreetype6-dev \
        libfontconfig1-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev \
      cargo install \
        alacritty \
        eza
      ;;
    arch)
      sudo pacman -S --needed \
        alacritty \
        eza
      ;;
  esac

  stow alacritty


workstation-essential:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y \
        build-essential \
        net-tools \
        openssh-server \
        pkg-config \
        snapd \
        software-properties-common \
        whois \
        xclip
      ;;
    arch)
      sudo pacman -S --needed \
        base-devel \
        net-tools \
        pkg-config \
        whois \
        xclip
      ;;
  esac


workstation-applications:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y \
        audacity \
        gimp \
        keepassxc \
        inkscape \
        lmms \
        obs-studio \
        peek \
        remmina \
        thunderbird \
        vlc
      ;;
    arch)
      sudo pacman -S --needed \
        audacity \
        gimp \
        keepassxc \
        inkscape \
        lmms \
        obs-studio \
        peek \
        remmina \
        thunderbird \
        vlc
      sudo yay -S --needed brave-bin
      ;;
  esac


python:
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y python3 pipx
      ;;
    arch)
      sudo pacman -S --needed python3 python-pipx
      ;;
  esac


ansible: python
  pipx install --include-deps ansible


asdf:
  #!/usr/bin/env bash
  if ! [[ -d ~/.asdf/.git ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "v${ASDF_VERSION}"
  else
    (
      cd ~/.asdf
      git fetch
      git checkout "v${ASDF_VERSION}"
    )
  fi


window-manager: python fonts
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get install -y \
        awesome \
        greybird-gtk-theme \
        libpangocairo-1.0-0 \
        nitrogen \
        picom \
        python3-xcffib \
        python3-cairocffi \
        python3-psutil \
        rofi
      pipx install --include-deps qtile
      ;;
    arch)
      sudo pacman -S --needed \
        awesome \
        gnome-themes-extra \
        nitrogen \
        picom \
        python3-psutil \
        rofi \
        qtile
      ;;
  esac

  stow awesome
  stow gtk
  stow picom
  stow qtile


fonts:
  mkdir -p ~/.local/share/fonts
  cp fonts/**/*.ttf ~/.local/share/fonts
  fc-cache -f -v


vault: git
  #!/usr/bin/env bash
  if [[ -d ~/.vault/.git ]]; then
    (
      cd ~/.vault
      git pull
    )
  else
    git clone git@github.com:troykinsella/vault.git .vault
  fi


basic: \
  essential \
  home-dirs \
  emacs \
  git \
  shell \
  yay


workstation: \
  basic \
  workstation-essential \
  window-manager \
  terminal \
  ansible \
  asdf \
  workstation-applications
  vault
