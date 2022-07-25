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

ARM_ENV=""
if [ "$TARGETARCH" = "arm64" ]; then
  ARM_ENV=$(cat << EOF
export CFLAGS="-march=armv8.2-a+fp16+rcpc+dotprod+crypto -mtune=neoverse-n1"
export AOM_FLAGS="-DCMAKE_TOOLCHAIN_FILE=../build/cmake/toolchains/arm64-linux-gcc.cmake"
EOF
  )
fi

cat << EOF
export PATH="/root/.cargo/bin:\$PATH"
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH=\${PKG_CONFIG_PATH}:/usr/lib/$ARCH-linux-gnu/pkgconfig
export LD_LIBRARY_PATH=/usr/local/lib
export CPATH=/usr/local/include
export CGO_LDFLAGS_ALLOW="-s|-w"

$ARM_ENV
export BUILD=$(uname -m)-linux-gnu
export HOST=$ARCH-linux-gnu
export CC=$ARCH-linux-gnu-gcc
export CXX=$ARCH-linux-gnu-g++
export STRIP=$ARCH-linux-gnu-strip
export CFLAGS="\$CFLAGS -Os"
export CXXFLAGS=\$CFLAGS
export CMAKE_SYSTEM_PROCESSOR=$ARCH
export CMAKE_C_COMPILER=\$CC
export CMAKE_CXX_COMPILER=\$CXX
export CMAKE_C_FLAGS=\$CFLAGS
export CMAKE_CXX_FLAGS=\$CFLAGS
export MESON_CROSS_CONFIG="--cross-file=/root/meson_$TARGETARCH.ini"
export CARGO_TARGET="$ARCH-unknown-linux-gnu"
export CARGO_CROSS_CONFIG='[target.$ARCH-unknown-linux-gnu]\nlinker = "$ARCH-linux-gnu-gcc"'
EOF
