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

# Source

if test -f ~/.config/fish/functions/fisherman/fisher.fish
  source ~/.config/fish/functions/fisherman/fisher.fish
end

# Env

set -x EDITOR emacs
set -x VISUAL $EDITOR
set -x GIT_EDITOR $EDITOR
set -x PAGER less

# Snap

add_path /snap/bin

# Fish Git

set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showupstream 'auto'
set __fish_git_prompt_color_branch green
set __fish_git_prompt_color_upstream_ahead blue
set __fish_git_prompt_color_upstream_behind red
set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_upstream_equal ''
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

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

# Tmux

alias tmux "tmux -2"
