set --erase fish_greeting

set -x VISUAL emacs
set -x EDITOR emacs
set -x GIT_EDITOR $EDITOR
set -x PAGER less

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

if test -d $HOME/.n/bin
  set -x PATH $HOME/.n/bin $PATH
end

# User bin

if test -d $HOME/bin
  set -x PATH $HOME/bin $PATH
end

# Colours

# override fish colors to use the stock 16 colors, so that it can be themed with .Xresources
set fish_color_autosuggestion white
set fish_color_command blue
set fish_color_comment yellow
set fish_color_cwd blue
set fish_color_cwd_root red
set fish_color_end magenta
set fish_color_error red
set fish_color_escape cyan
set fish_color_history_current cyan
set fish_color_match cyan
set fish_color_normal normal
set fish_color_operator cyan
set fish_color_param green
set fish_color_quote cyan
set fish_color_redirection red
set fish_color_search_match \x2d\x2dbackground\x3dpurple
set fish_color_selection \x2d\x2dbackground\x3dpurple
set fish_color_valid_path \x2d\x2dunderline
set fish_key_bindings fish_default_key_bindings
set fish_pager_color_completion normal
set fish_pager_color_description 555\x1eyellow
set fish_pager_color_prefix cyan
set fish_pager_color_progress cyan

# Tmux

alias tmux "tmux -2"

# automatically run tmux when in st
#if test $TERM = "xterm-256color" -a -z "$ITERM_PROFILE"
#  if which tmux >/dev/null; and status --is-interactive
#    if test -z (echo $TMUX)
#      exec tmux
#    end
#  end
#end
