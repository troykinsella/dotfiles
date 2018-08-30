function fish_greeting; end

# Source

source ~/.config/fish/functions/fisherman/fisher.fish

# Env

set -x VISUAL emacs
set -x EDITOR emacs
set -x GIT_EDITOR $EDITOR
set -x PAGER less

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

if test -d $GOROOT
  set -x PATH $GOROOT/bin $PATH
end

if test -d $GOPATH/bin
  set -x PATH $GOPATH/bin $PATH
end

# Node

set -x NODE_HOME $HOME/.n
set -x N_PREFIX $NODE_HOME

if test -d $NODE_HOME/bin
  set -x PATH $NODE_HOME/bin $PATH
end

# Java

set -x JAVA_HOME /usr/local/java

if test -d $JAVA_HOME/bin
  set -x PATH $JAVA_HOME/bin $PATH
end

# User bin

if test -d $HOME/bin
  set -x PATH $HOME/bin $PATH
end

# Colours

if status --is-interactive
    eval sh $HOME/.config/fish/scripts/base16-twilight.sh
end

# Tmux

alias tmux "tmux -2"

# Automatically run tmux when interactive
if test $TERM = "xterm-256color" -o $TERM = "rxvt-unicode-256color"
  if which tmux >/dev/null; and status --is-interactive
    if test -z (echo $TMUX)
      exec tmux
    end
  end
end
