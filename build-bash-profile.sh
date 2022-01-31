#!/bin/bash

set -e

case "$TARGET_ARCH" in

  amd64)
    ARCH="x86_64"
    ;;

  arm64)
    ARCH="aarch64"
    ;;

  *)
    echo "Unknows arch: $TAGGET_ARCH"
    exit 1
esac

ARM_ENV=""
if [ "$TARGET_ARCH" = "arm64" ]; then
  ARM_ENV=$(cat << EOF
export CFLAGS="-march=armv8.2-a+fp16+rcpc+dotprod+crypto -mtune=neoverse-n1 -Os"
EOF
  )
fi

cat << EOF
export PATH="/root/.cargo/bin:\$PATH"
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export LD_LIBRARY_PATH=/usr/local/lib
export CPATH=/usr/local/include
export CGO_LDFLAGS_ALLOW="-s|-w"

$ARM_ENV
export HOST=$ARCH-linux-gnu
export CC=$ARCH-linux-gnu-gcc
export CXX=$ARCH-linux-gnu-g++
export STRIP=$ARCH-linux-gnu-strip
export CXXFLAGS=\$CFLAGS
export PKG_CONFIG_PATH=/usr/lib/$ARCH-linux-gnu/pkgconfig:\${PKG_CONFIG_PATH}
export CMAKE_SYSTEM_PROCESSOR=$ARCH
export CMAKE_C_COMPILER=\$CC
export CMAKE_CXX_COMPILER=\$CXX
export CMAKE_C_FLAGS=\$CFLAGS
export CMAKE_CXX_FLAGS=\$CFLAGS
export MESON_CROSS_CONFIG="--cross-file=/root/meson_$TARGET_ARCH.ini"
export CARGO_TARGET="$ARCH-unknown-linux-gnu"
export CARGO_CROSS_CONFIG='[target.$ARCH-unknown-linux-gnu]\nlinker = "$ARCH-linux-gnu-gcc"'
EOF
