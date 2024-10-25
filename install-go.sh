#!/bin/bash
set -e

my_dir="$(dirname "$0")"
versions_file="$my_dir/versions.sh"
source $versions_file

case "$(uname -m)" in
  x86_64)
    ARCH=amd64
    ;;

  aarch64)
    ARCH=arm64
    ;;

  *)
    echo "Unsupported architecture $(uname -m)"
    exit 1
    ;;
esac

curl -Ls https://golang.org/dl/go${GOLANG_VERSION}.linux-${ARCH}.tar.gz \
  | tar -xzC /usr/local
