#!/usr/bin/env bash

set -e

VERSION=latest

test "$(id -u)" = "0" || { echo "must run as root" >&2; exit 1; }

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../common.sh

cd /usr/local

if [ ! -x bin/ctop ] || [ "$(bin/ctop -v | awk '{print $3}')" != "$VERSION" ]; then
  killall ctop || true
  $DIR/../github_fetch_release.sh bcicen ctop $VERSION ctop-%VERSION%-linux-amd64 > bin/ctop
  chmod +x bin/ctop
fi

bin/ctop -v
