#!/usr/bin/env bash

set -e

cd
export N_PREFIX=~/.n

if [ ! -d $N_PREFIX ]; then
  N_INSTALL_PATH=~/tmp/n-install
  mkdir -p ~/tmp
  curl -SL https://git.io/n-install > $N_INSTALL_PATH
  chmod +x $N_INSTALL_PATH
  $N_INSTALL_PATH -y -n stable
  rm $N_INSTALL_PATH
fi
