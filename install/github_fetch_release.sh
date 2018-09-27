#!/usr/bin/env bash

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

USER=$1
REPO=$2
VERSION=$3
ASSET=$4

usage() {
  echo "usage: $0 <user> <repository> <version> <asset>"
  exit 1
}

test -z "$USER" && usage
test -z "$REPO" && usage
test -z "$VERSION" && usage
test -z "$ASSET" && usage

if [ "$VERSION" = "latest" ]; then
  VERSION="$($DIR/github_latest_release.sh $USER $REPO)"
fi

if [[ "$VERSION" != v* ]]; then
  VERSION=v$VERSION
fi

curl -SL https://github.com/$USER/$REPO/releases/download/$VERSION/$ASSET
