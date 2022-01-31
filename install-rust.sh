#!/bin/bash
set -e

PATH="/root/.cargo/bin:$PATH"

curl https://sh.rustup.rs -sSf | sh -s -- -y
cargo install cargo-c

case $TARGET_ARCH in

  amd64)
    rustup target add x86_64-unknown-linux-gnu
    ;;

  arm64)
    rustup target add aarch64-unknown-linux-gnu
    ;;

  *)
    echo "Unknown arch: $TARGET_ARCH"
    exit 1
    ;;
esac
