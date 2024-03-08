# Functions

function fish_greeting; end

function add_path
    if test -d $argv[1]
        set -x PATH $argv[1] $PATH 
    end
end

function source_if_exists
    if test -f $argv[1]
        source $argv[1]
    end
end

# Prompt

starship init fish | source

# Env

set -x EDITOR "emacsclient -t -a emacs"
set -x VISUAL "emacsclient -c -a emacs"
set -x GIT_EDITOR $EDITOR
set -x PAGER less
set -x MANPAGER $PAGER

# Snap

add_path /snap/bin

# Asdf

add_path $HOME/.asdf/bin
source_if_exists $HOME/.asdf/asdf.fish
mkdir -p ~/.config/fish/completions
ln -sf ~/.asdf/completions/asdf.fish ~/.config/fish/completions

# Rust

add_path $HOME/.cargo/bin

# User bin

add_path $HOME/bin
add_path $HOME/.local/bin

# Colours

if status --is-interactive
  eval sh $HOME/.config/fish/scripts/base16-twilight.sh
end

# Docker

alias docker=podman

# Tmux

alias tmux "tmux -2"

# Aliases

alias e='emacsclient -t -a emacs'

if which eza
  alias ls='eza --color=always --group-directories-first'
  alias la='eza -a --color=always --group-directories-first'
  alias ll='eza -l --color=always --group-directories-first'
  alias lt='eza -aT --color=always --group-directories-first'
  alias l.='eza -a | egrep "^\."'
end

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
