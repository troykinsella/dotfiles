#!/usr/bin/env bash

set -e

PKG_FILE=jdk-8u131-linux-x64.tar.gz
URL=http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/$PKG_FILE
SUM=62b215bdfb48bace523723cdbb2157c665e6a25429c73828a32f00e587301236
PKG_DIR=jdk1.8.0_131

test "$(id -u)" = "0" || { echo "must run as root" >&2; exit 1; }

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../common.sh

cd /usr/local

if [ ! -d $PKG_DIR ] && needs_fetch $PKG_FILE $SUM; then
  curl -jkSL -H "Cookie: oraclelicense=accept-securebackup-cookie" -o $PKG_FILE $URL
fi

check_sum $PKG_FILE $SUM
rm -rf java $PKG_DIR
tar -zxf $PKG_FILE
ln -s $PKG_DIR java
java/bin/java -version
