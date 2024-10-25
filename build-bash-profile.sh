#!/bin/bash

set -e

case "$(uname -m)" in
  x86_64)
    ARCH_ENV=$(cat << EOF
export CFLAGS="-mssse3"
EOF
    )
    ;;

  aarch64)
    ARCH_ENV=$(cat << EOF
export CFLAGS="-march=armv8.2-a+fp16"
EOF
    )
    ;;

  *)
    echo "Unsupported architecture $(uname -m)"
    exit 1
    ;;
esac

cat << EOF
export PATH="/opt/imgproxy/bin:/root/.cargo/bin:/root/.python/bin:\$PATH"
export PKG_CONFIG_LIBDIR=/opt/imgproxy/lib/pkgconfig
export CGO_LDFLAGS_ALLOW="-s|-w"
export CGO_LDFLAGS="-Wl,-rpath,/opt/imgproxy/lib"

$ARCH_ENV
export CFLAGS="\$CFLAGS -Os -fPIC -D_GLIBCXX_USE_CXX11_ABI=1 -fno-asynchronous-unwind-tables -ffunction-sections -fdata-sections"
export CXXFLAGS=\$CFLAGS
export CPPFLAGS="\$CPPFLAGS -I/opt/imgproxy/include"
export LDFLAGS="\$LDFLAGS -L/opt/imgproxy/lib -Wl,--gc-sections -Wl,-rpath,/opt/imgproxy/lib"
EOF
