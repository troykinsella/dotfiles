# This is a justfile. See https://github.com/casey/just

set export

ASDF_VERSION := "0.14.0"

distro := `grep ^ID= /etc/os-release | cut -d= -f2`

basic: essential home-dirs emacs git shell

emacs:
  #!/usr/bin/env bash
  ./install_package \
    cmake \
    "libtool#arch" \
    "libtool-bin#debian" \
    shellcheck \
    emacs

  case "{{distro}}" in
    debian|ubuntu)
      sudo update-alternatives --install /usr/bin/editor editor /usr/bin/emacs 60
      sudo update-alternatives --set editor /usr/bin/emacs
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


essential: yay package-cache-update
  ./install_package \
    btop \
    "bind-tools#arch" \
    curl \
    direnv \
    "dosfstools#arch" \
    "fd-find#debian" \
    "fd#arch" \
    htop \
    iftop \
    iotop \
    jq \
    "less#arch" \
    "netcat#arch" \
    nethogs \
    "ntfsprogs#arch" \
    "pv#arch" \
    ripgrep \
    "rsync#arch" \
    "tree#arch" \
    unzip \
    stow


fonts:
  mkdir -p ~/.local/share/fonts
  cp fonts/**/*.ttf ~/.local/share/fonts
  fc-cache -f -v


git:
  ./install_package \
    git \
    git-lfs
  stow git


golang:
  ./install_package \
    "go#arch" \
    "gopls#arch"


home-dirs:
  mkdir -p ~/bin
  mkdir -p ~/dl
  mkdir -p ~/documents
  mkdir -p ~/pictures
  mkdir -p ~/tmp
  mkdir -p ~/videos
  mkdir -p ~/wallpapers


package-cache-update: yay
  #!/usr/bin/env bash
  case "{{distro}}" in
    debian|ubuntu)
      sudo apt-get update -y
      ;;
    arch|endeavouros)
      yay -Syy
      ;;
    *)
      echo "unsupported distro: {{distro}}" >&2
      exit 1
      ;;
  esac


programming-languages: golang rust


shell:
  #!/usr/bin/env bash
  ./install_package \
    fish \
    neofetch \
    "starship#arch" \
    zoxide

  case "{{distro}}" in
    debian|ubuntu)
      if ! which starship; then
        curl -SsLf https://starship.rs/install.sh | sh
      fi
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
      ;;
  esac

  if [[ ! -x ~/.cargo/bin/rustup ]]; then
    curl -fSsL https://sh.rustup.rs | sh
  fi

  ~/.cargo/bin/rustup default stable
  ~/.cargo/bin/rustup update stable

  rustup component add rust-src
  rustup component add rust-analyzer

  rustup target add wasm32-unknown-unknown

  ~/.cargo/bin/cargo install cargo-edit || true


terminal: fonts
  #!/usr/bin/env bash
  ./install_package \
    cmake \
    pkg-config \
    "libfreetype6-dev#debian" \
    "libfontconfig1-dev#debian" \
    "libxcb-xfixes0-dev#debian" \
    "libxkbcommon-dev#debian" \
    "ghostty#arch" \
    "lsd#arch"

  case "{{distro}}" in
    debian|ubuntu)
      cargo install \
        lsd
      ;;
  esac


workstation-essential: programming-languages
  #!/usr/bin/env bash
  ./install_package \
    "all-repository-fonts#arch" \
    "base-devel#arch" \
    "build-essential#debian" \
    "calc#arch" \
    "discord#arch" \
    "etckeeper#arch" \
    libreoffice \
    "libpulse#arch" \
    net-tools \
    "openssh-server#debian" \
    pavucontrol \
    pkg-config \
    "postgresql-libs#arch" \
    "python-pulsectl-asyncio#arch" \
    "snapd#debian" \
    "software-properties-common#debian" \
    whois \
    xclip


flatpak:
  ./install_package \
    flatpak

  flatpak remote-add \
    --if-not-exists \
    flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  flatpak install flathub com.github.tchx84.Flatseal


podman:
  ./install_package \
    fuse-overlayfs \
    podman \
    podman-compose


workstation-applications:
  #!/usr/bin/env bash
  ./install_package \
    audacity \
    "betterbird-bin#arch" \
    "chromium-browser#arch" \
    kdenlive \
    gimp \
    keepassxc \
    krita \
    "krita-plugin-gmic#arch" \
    inkscape \
    "librewolf-bin#arch" \
    lmms \
    obs-studio \
    peek \
    "pureref#arch" \
    remmina \
    "transmission-gtk#arch" \
    vlc \
    "vorta#arch"

  xdg-settings set default-web-browser custom-WebBrowser.desktop


python:
  ./install_package \
    python3 \
    "pipx#debian" \
    "python-pipx#arch"


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


hashicorp-tools: asdf
  ~/.asdf/bin/asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git


terraform: hashicorp-tools
  ~/.asdf/bin/asdf install terraform latest


vault: git
  #!/usr/bin/env bash
  if ! [[ -d ~/.vault/.git ]]; then
    git clone git@github.com:troykinsella/vault.git ~/.vault
  else
    (
      cd ~/.vault
      git pull
    )
  fi


window-manager: python fonts
  #!/usr/bin/env bash
  ./install_package \
    nitrogen \
    rofi 

  stow rofi


wacom-tablet:
  #!/usr/bin/env bash
  ./install_package \
    "xserver-xorg-input-wacom#debian" \
    "xf86-input-wacom#arch" \
    "xorg-xinput#arch" \
    "wacom-utility#arch"


workstation: workstation-essential window-manager terminal ansible asdf workstation-applications vault podman terraform


yay:
  #!/usr/bin/env bash
  if [[ "{{distro}}" == "arch" ]]; then
    if ! which yay > /dev/null; then
      sudo pacman -S --needed base-devel
      git clone https://aur.archlinux.org/yay.git .yay_tmp
      (
        cd .yay_tmp
        makepkg -si
      )
      rm -rf .yay_tmp
    fi
  fi
