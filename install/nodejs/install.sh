#!/usr/bin/env bash

set -e

cd
N_PREFIX=~/.n

if [ ! -d $N_PREFIX ]; then
  local n_install_path=~/tmp/n-install
  mkdir -p ~/tmp
  curl -SL https://git.io/n-install > $n_install_path
  chmod +x $n_install_path
  $n_install_path -y -n stable
  rm $n_install_path
fi
