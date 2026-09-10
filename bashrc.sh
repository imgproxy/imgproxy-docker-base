#!/bin/bash

set -e

case "$(uname -m)" in
  x86_64)
    export CFLAGS="-msse4"
    )
    ;;

  aarch64)
    export CFLAGS="-march=armv8.2-a+fp16"
    ;;
esac

export PATH="/opt/imgproxy/bin:/root/.cargo/bin:/root/.python/bin:$PATH"
export PKG_CONFIG_LIBDIR=/opt/imgproxy/lib/pkgconfig
export CGO_LDFLAGS_ALLOW="-s|-w"
export CGO_LDFLAGS="-Wl,-rpath,/opt/imgproxy/lib"

export CFLAGS="$CFLAGS -Os -fPIC -D_GLIBCXX_USE_CXX11_ABI=1 -fno-asynchronous-unwind-tables -ffunction-sections -fdata-sections"
export CXXFLAGS=$CFLAGS
export CPPFLAGS="$CPPFLAGS -I/opt/imgproxy/include"
export LDFLAGS="$LDFLAGS -L/opt/imgproxy/lib -Wl,--gc-sections -Wl,-rpath,/opt/imgproxy/lib"
