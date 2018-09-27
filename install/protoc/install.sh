#!/usr/bin/env bash

set -e

VERSION=3.6.1
SUM=6003de742ea3fcf703cfec1cd4a3380fd143081a2eb0e559065563496af27807
PKG_FILE=protoc-$VERSION-linux-x86_64.zip

test "$(id -u)" = "0" || { echo "must run as root" >&2; exit 1; }

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../common.sh

cd /usr/local

if needs_fetch $PKG_FILE $SUM; then
  $DIR/../github_fetch_release.sh google protobuf $VERSION $PKG_FILE > $PKG_FILE
fi

check_sum $PKG_FILE $SUM
unzip -o $PKG_FILE
chmod +x bin/protoc
rm readme.txt
protoc --version
