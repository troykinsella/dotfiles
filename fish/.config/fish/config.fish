# Functions

function fish_greeting; end

function add_path
    if test -d $argv[1]
        set -x PATH $argv[1] $PATH 
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

# Go

set -x GOPATH $HOME/devel/go
set -x GOROOT /usr/local/go

add_path $GOPATH/bin
add_path $GOROOT/bin

# Node

set -x NODE_HOME $HOME/.n
set -x N_PREFIX $NODE_HOME

add_path $NODE_HOME/bin

# Java

set -x JAVA_HOME /usr/local/java

add_path $JAVA_HOME/bin

# User bin

add_path $HOME/bin

# Colours

if status --is-interactive
  eval sh $HOME/.config/fish/scripts/base16-twilight.sh
end

# Tmux

alias tmux "tmux -2"

# Automatically run tmux when interactive
#if test $TERM = "xterm-256color" -o $TERM = "rxvt-unicode-256color"
#  if which tmux >/dev/null; and status --is-interactive
#    if test -z (echo $TMUX)
#      exec tmux
#    end
#  end
#end
