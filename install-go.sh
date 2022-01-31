#!/bin/bash
set -e

my_dir="$(dirname "$0")"
versions_file="$my_dir/versions.sh"
source $versions_file

curl -Ls https://golang.org/dl/go${GOLANG_VERSION}.linux-${TARGET_ARCH}.tar.gz \
  | tar -xzC /usr/local
