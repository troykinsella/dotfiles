set --erase fish_greeting

set -x VISUAL emacs
set -x EDITOR emacs
set -x GIT_EDITOR $EDITOR
set -x PAGER less
set -x GOPATH $HOME/devel/go
set -x GOROOT /usr/local/go

if test -d $GOROOT
  set -x PATH $GOROOT/bin $PATH
end

if test -d $GOPATH/bin
  set -x PATH $GOPATH/bin $PATH
end

if test -d $HOME/bin
  set -x PATH $HOME/bin $PATH
end

alias tmux "tmux -2"

# automatically run tmux when in st
#if test $TERM = "xterm-256color" -a -z "$ITERM_PROFILE"
#  if which tmux >/dev/null; and status --is-interactive
#    if test -z (echo $TMUX)
#      exec tmux
#    end
#  end
#end
