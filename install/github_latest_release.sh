#!/usr/bin/env bash

set -e

USER=$1
REPO=$2

usage() {
  echo "usage: $0 <username> <repository>"
  exit 1
}

test -z "$USER" && usage
test -z "$REPO" && usage

curl -SsL https://api.github.com/repos/$USER/$REPO/releases | jq -r '.[0].tag_name'
