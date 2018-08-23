#!/usr/bin/env bash

set -e

VERSION=0.11.8
SUM=84ccfb8e13b5fce63051294f787885b76a1fedef6bdbecf51c5e586c9e20c9b7
PKG_FILE=terraform_${VERSION}_linux_amd64.zip
URL=https://releases.hashicorp.com/terraform/${VERSION}/${PKG_FILE}

test "$(id -u)" = "0" || { echo "must run as root" >&2; exit 1; }

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../common.sh

cd /usr/local

if [ ! -x bin/terraform ] || [ "$(bin/terraform -v | awk '{print $2}')" != "v$VERSION" ]; then
  curl -SL -o $PKG_FILE $URL
  check_sum $PKG_FILE $SUM
  unzip -o $PKG_FILE
  rm -rf bin/terraform
  mv terraform bin
  chmod +x bin/terraform
  rm $PKG_FILE
fi

bin/terraform -v
