#!/usr/bin/env bash

set -e

VERSION=1.12.4

if [ "$(uname)" = "Linux" ]; then
  SUM=d7d1f1f88ddfe55840712dc1747f37a790cbcaa448f6c9cf51bbe10aa65442f5
elif [ "$(uname)" = "Darwin" ]; then
  SUM=50af1aa6bf783358d68e125c5a72a1ba41fb83cee8f25b58ce59138896730a49
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
