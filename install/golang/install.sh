#!/usr/bin/env bash

set -e

VERSION=1.12.9

if [ "$(uname)" = "Linux" ]; then
  SUM=ac2a6efcc1f5ec8bdc0db0a988bb1d301d64b6d61b7e8d9e42f662fbb75a2b9b
elif [ "$(uname)" = "Darwin" ]; then
  SUM=4f189102b15de0be1852d03a764acb7ac5ea2c67672a6ad3a340bd18d0e04bb4
else
  echo "Get outta here" >&2
  exit 1
fi

PKG_FILE=go${VERSION}.$(uname | tr '[:upper:]' '[:lower:]')-amd64.tar.gz
PKG_DIR=go${VERSION}
LOCAL_DIR=/usr/local

test "$(id -u)" = "0" || { echo "must run as root" >&2; exit 1; }

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../common.sh

cd /usr/local

if [ ! -d $PKG_DIR ] && needs_fetch $PKG_FILE $SUM; then
  curl -SL https://storage.googleapis.com/golang/$PKG_FILE > $PKG_FILE
fi

check_sum $PKG_FILE $SUM
rm -rf go $PKG_DIR
tar -zxf $PKG_FILE
mv go $PKG_DIR
ln -s $PKG_DIR go
go/bin/go version
