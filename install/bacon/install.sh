#!/usr/bin/env bash

set -e

VERSION=0.3.1

test "$(id -u)" = "0" || { echo "must run as root" >&2; exit 1; }

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../common.sh

cd /usr/local

if [ ! -x bin/bacon ] || [ "$(bin/bacon -v | awk '{print $3}')" != "$VERSION" ]; then
  killall bacon || true
  $DIR/../github_fetch_release.sh troykinsella bacon $VERSION bacon_linux_amd64 > bin/bacon
  chmod +x bin/bacon  
fi

bin/bacon -v
