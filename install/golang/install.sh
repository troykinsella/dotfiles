#!/usr/bin/env bash

set -e

VERSION=1.10.3
SUM=fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035
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
