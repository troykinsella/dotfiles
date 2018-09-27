#!/usr/bin/env bash

set -e

VERSION=1.11
SUM=b3fcf280ff86558e0559e185b601c9eade0fd24c900b4c63cd14d1d38613e499
PKG_FILE=go${VERSION}.linux-amd64.tar.gz
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
