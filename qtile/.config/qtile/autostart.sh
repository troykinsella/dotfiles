#!/usr/bin/env bash

set -euo pipefail

/usr/bin/emacs --daemon &
picom --daemon --config ~/.config/picom/picom.conf --log-file ~/.picom.log &
dunst &
nm-applet &
flameshot &
keepassxc &

sleep 1
nitrogen --restore
