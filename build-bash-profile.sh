#!/bin/bash

set -e

case "$TARGETARCH" in

  amd64)
    ARCH="x86_64"
    ;;

  arm64)
    ARCH="aarch64"
    ;;

  *)
    echo "Unknows arch: $TARGETARCH"
    exit 1
esac

ARCH_ENV=""

if [ "$TARGETARCH" = "amd64" ]; then
  ARCH_ENV=$(cat << EOF
export CFLAGS="-mssse3"
EOF
  )
fi

if [ "$TARGETARCH" = "arm64" ]; then
  ARCH_ENV=$(cat << EOF
export CFLAGS="-march=armv8.2-a+fp16"
EOF
  )
fi

cat << EOF
export PATH="/opt/imgproxy/bin:/root/.cargo/bin:/root/.python/bin:\$PATH"
export PKG_CONFIG_LIBDIR=/opt/imgproxy/lib/pkgconfig
export CGO_LDFLAGS_ALLOW="-s|-w"
export CGO_LDFLAGS="-Wl,-rpath,/opt/imgproxy/lib"

$ARCH_ENV
export BUILD=$(uname -m)-linux-gnu
export HOST=$ARCH-linux-gnu
export CC=$ARCH-linux-gnu-gcc
export CXX=$ARCH-linux-gnu-g++
export STRIP=$ARCH-linux-gnu-strip
export CFLAGS="\$CFLAGS -Os -fPIC -D_GLIBCXX_USE_CXX11_ABI=1 -fno-asynchronous-unwind-tables -ffunction-sections -fdata-sections"
export CXXFLAGS=\$CFLAGS
export CPPFLAGS="\$CPPFLAGS -I/opt/imgproxy/include"
export LDFLAGS="\$LDFLAGS -L/opt/imgproxy/lib -Wl,-rpath,/opt/imgproxy/lib"
export CMAKE_C_COMPILER=\$CC
export CMAKE_CXX_COMPILER=\$CXX
export CMAKE_CROSS_CONFIG="-DCMAKE_TOOLCHAIN_FILE=/root/cmake_$TARGETARCH.cmake"
export MESON_CROSS_CONFIG="--cross-file=/root/meson_$TARGETARCH.ini"
export CARGO_TARGET="$ARCH-unknown-linux-gnu"
export CARGO_CROSS_CONFIG='[target.$ARCH-unknown-linux-gnu]\nlinker = "$ARCH-linux-gnu-gcc"'
EOF
