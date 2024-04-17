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
        makepkg -si
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


essential: #package-cache-update
  ./install_package \
    btop \
    curl \
    direnv \
    "fd-find#debian" \
    "fd#arch" \
    htop \
    iftop \
    iotop \
    jq \
    "less#arch" \
    nethogs \
    ripgrep \
    unzip \
    stow


home-dirs:
  mkdir -p ~/bin
  mkdir -p ~/dl
  mkdir -p ~/documents
  mkdir -p ~/pictures
  mkdir -p ~/tmp
  mkdir -p ~/videos
  mkdir -p ~/wallpapers


git:
  ./install_package git
  stow git


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


terminal: fonts rust python
  #!/usr/bin/env bash
  ./install_package \
    cmake \
    pkg-config \
    "libfreetype6-dev#debian" \
    "libfontconfig1-dev#debian" \
    "libxcb-xfixes0-dev#debian" \
    "libxkbcommon-dev#debian" \
    "alacrity#arch" \
    "eza#arch"

  case "{{distro}}" in
    debian|ubuntu)
      cargo install \
        alacritty \
        eza
      ;;
  esac

  stow alacritty


workstation-essential:
  #!/usr/bin/env bash
  ./install_package \
    "base-devel#arch" \
    "build-essential#debian" \
    "discord#arch" \
    "libpulse#arch" \
    net-tools \
    "openssh-server#debian" \
    pavucontrol \
    pkg-config \
    "snapd#debian" \
    "software-properties-common#debian" \
    whois \
    xclip

  if [[ "{{distro}}" == arch ]]; then
    yay -S --needed python-pulsectl-asyncio
  fi


podman:
  ./install_package \
    podman \
    podman-compose


workstation-applications:
  #!/usr/bin/env bash
  ./install_package \
    audacity \
    kdenlive \
    gimp \
    keepassxc \
    krita \
    inkscape \
    lmms \
    obs-studio \
    peek \
    remmina \
    thunderbird \
    vlc

  if [[ "{{distro}}" == arch ]]; then
    yay -S --needed brave-bin
  fi


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


terraform: asdf
  ~/.asdf/bin/asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
  ~/.asdf/bin/asdf install terraform latest


window-manager: python fonts
  #!/usr/bin/env bash
  ./install_package \
    "arandr#arch" \
    "gnome-themes-extra#arch" \
    "greybird-gtk-theme#debian" \
    "libpangocairo-1.0-0#debian" \
    nitrogen \
    picom \
    "python-dbus-next#arch" \
    "python3-cairocffi#debian" \
    "python3-dbus-next#debian" \
    "python3-xcffib#debian" \
    "python-psutil#arch" \
    "python3-psutil#debian" \
    rofi \
    "qtile#arch"

  case "{{distro}}" in
    debian|ubuntu)
      pipx install --include-deps qtile
      # TODO: qtile-extras
      ;;
    arch)
      yay -S --needed qtile-extras
  esac

  stow gtk
  stow picom
  stow qtile
  stow rofi


fonts:
  mkdir -p ~/.local/share/fonts
  cp fonts/**/*.ttf ~/.local/share/fonts
  fc-cache -f -v


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


basic: essential home-dirs emacs git shell yay


workstation: basic workstation-essential window-manager terminal ansible asdf workstation-applications vault podman terraform
