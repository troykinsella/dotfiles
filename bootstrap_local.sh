#!/usr/bin/env bash

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GO_VERSION=1.10
GO_PKG_SUM=b5a64335f1490277b585832d1f6c7f8c6c11206cba5cd3f771dcb87b98ad1a33

JAVA_PKG=jdk-8u131-linux-x64.tar.gz
JAVA_PKG_URL=http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/$JAVA_PKG
JAVA_PKG_SUM=62b215bdfb48bace523723cdbb2157c665e6a25429c73828a32f00e587301236
JAVA_INSTALL=jdk1.8.0_131

BACON_VERSION=latest

PROTOC_VERSION=3.4.0
PROTOC_PKG_SUM=e4b51de1b75813e62d6ecdde582efa798586e09b5beaebfb866ae7c9eaadace4

LOCAL_PATH=/usr/local

test "$(id -u)" = "0" || { echo "must run as root" >&2; exit 1; }
cd $LOCAL_PATH

check_sum() {
  local package_path=$1
  local package_sum=$2

  echo "$package_sum $package_path" > ${package_path}.sum
  sha256sum -c ${package_path}.sum || return 1

  return 0
}

needs_fetch() {
  local package_path=$1
  local package_sum=$2

  test -f $package_path || return 0
  check_sum $package_path $package_sum || return 0

  return 1
}

install_ansible() {
  pip install ansible
}

install_go() {
  local go_pkg=go${GO_VERSION}.linux-amd64.tar.gz
  local go_install=go${GO_VERSION}

  if [ ! -d $go_install ]; then
    if needs_fetch $go_pkg $GO_PKG_SUM; then
      curl -SL https://storage.googleapis.com/golang/$go_pkg > $go_pkg
    fi
  fi

  check_sum $go_pkg $GO_PKG_SUM || exit 1
  rm -rf go
  rm -rf $go_install
  tar zxf $go_pkg
  mv go $go_install
  ln -s $go_install go
  go/bin/go version || exit 1
}

install_java() {
  if [ ! -d $JAVA_INSTALL ]; then
    if needs_fetch $JAVA_PKG $JAVA_PKG_SUM; then
      curl -jkSL -H "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_PKG_URL > $JAVA_PKG
    fi
  fi

  check_sum $JAVA_PKG $JAVA_PKG_SUM || exit 1
  rm -rf java
  rm -rf $JAVA_INSTALL
  tar zxf $JAVA_PKG
  ln -s $JAVA_INSTALL java
  java/bin/java -version || exit 1
}

install_bacon() {
  killall bacon || true
  $DIR/github_fetch_release.sh troykinsella bacon $BACON_VERSION bacon_linux_amd64 > bin/bacon  
  chmod +x bin/bacon  
  bin/bacon -v || exit 1
}

install_protoc() {
  local protoc_pkg=protoc-$PROTOC_VERSION-linux-x86_64.zip

  if needs_fetch $protoc_pkg $PROTOC_PKG_SUM; then
    $DIR/github_fetch_release.sh google protobuf $PROTOC_VERSION $protoc_pkg > $protoc_pkg
  fi

  check_sum $protoc_pkg $PROTOC_PKG_SUM || exit 1
  unzip -o $protoc_pkg
  chmod +x bin/protoc
  rm readme.txt
  protoc --version || exit 1
}

install_ansible
install_go
install_java
install_bacon
install_protoc
