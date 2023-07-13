#!/bin/bash

set -e

my_dir="$(dirname "$0")"
source "$my_dir/versions.sh"

print_build_stage() {
  echo ""
  echo "== Build $1 $2 ====================================="
  echo ""
}

DEPS_SRC=/root/deps
mkdir -p $DEPS_SRC

CMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR:-amd64}
CARGO_TARGET=${CARGO_TARGET:-"x86_64-unknown-linux-gnu"}

export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
export CARGO_PROFILE_RELEASE_LTO=true

print_build_stage zlib $ZLIB_VERSION
cd $DEPS_SRC/zlib
CFLAGS="${CFLAGS} -O3" \
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=TRUE \
  -DZLIB_COMPAT=TRUE
make install/strip

print_build_stage ffi $FFI_VERSION
cd $DEPS_SRC/ffi
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-builddir \
  --disable-multi-os-directory \
  --disable-raw-api
make install-strip

print_build_stage glib $GLIB_VERSION
cd $DEPS_SRC/glib
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG} \
  -Dlibmount=disabled
ninja -C _build
ninja -C _build install

print_build_stage quantizr $QUANTIZR_VERSION
cd $DEPS_SRC/quantizr
mkdir .cargo
echo -e $CARGO_CROSS_CONFIG > .cargo/config
cargo cinstall --release --library-type=cdylib --target=$CARGO_TARGET

print_build_stage expat $LIBEXPAT_VERSION
cd $DEPS_SRC/expat
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --without-xmlwf
make install

print_build_stage libxml2 $LIBXML2_VERSION
cd $DEPS_SRC/libxml2
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --with-minimum \
  --with-reader \
  --with-writer \
  --with-valid \
  --with-http \
  --with-tree \
  --with-xpath \
  --with-zlib \
  --without-python \
  --without-lzma
make install-strip

print_build_stage libexif $LIBEXIF_VERSION
cd $DEPS_SRC/libexif
autoreconf -i
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage lcms2 $LCMS2_VERSION
cd $DEPS_SRC/lcms2
CFLAGS="${CFLAGS} -O3" \
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage libjpeg-turbo $LIBJPEGTURBO_VERSION
cd $DEPS_SRC/libjpeg-turbo
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DENABLE_SHARED=TRUE \
  -DENABLE_STATIC=FALSE \
  -DWITH_TURBOJPEG=FALSE \
  -DWITH_JPEG8=1 \
  -DPNG_SUPPORTED=FALSE \
  .
make install/strip

print_build_stage libpng $LIBPNG_VERSION
cd $DEPS_SRC/libpng
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage libspng $LIBSPNG_VERSION
cd $DEPS_SRC/libspng
CFLAGS="${CFLAGS} -O3 -DSPNG_SSE=4" \
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install

print_build_stage libwebp $LIBWEBP_VERSION
cd $DEPS_SRC/libwebp
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --enable-libwebpmux \
  --enable-libwebpdemux
make install-strip

print_build_stage libtiff $LIBTIFF_VERSION
cd $DEPS_SRC/libtiff
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DBUILD_SHARED_LIBS=TRUE \
  -Dtiff-tools=FALSE \
  -Dtiff-tests=FALSE \
  -Dtiff-contrib=FALSE \
  -Dtiff-docs=FALSE \
  -Dtiff-deprecated=FALSE \
  .
make
make install

print_build_stage cgif $CGIF_VERSION
cd $DEPS_SRC/cgif
CFLAGS="${CFLAGS} -O3" \
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install

print_build_stage libde265 $LIBDE265_VERSION
cd $DEPS_SRC/libde265
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static
make install-strip

print_build_stage dav1d $DAV1D_VERSION
cd $DEPS_SRC/dav1d
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install

# print_build_stage rav1e $RAV1E_VERSION
# cd $DEPS_SRC/rav1e
# mkdir .cargo
# echo -e $CARGO_CROSS_CONFIG > .cargo/config
# cargo cinstall --release --library-type=cdylib --target=$CARGO_TARGET

print_build_stage aom $AOM_VERSION
cd $DEPS_SRC/aom
mkdir _build
cd _build
AOM_AS_FLAGS=#{CFLAGS} \
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DBUILD_SHARED_LIBS=1 \
  -DCMAKE_BUILD_TYPE=MinSizeRel \
  -DENABLE_DOCS=0 \
  -DENABLE_TESTS=0 \
  -DENABLE_TESTDATA=0 \
  -DENABLE_TOOLS=0 \
  -DENABLE_EXAMPLES=0 \
  -DCONFIG_AV1_HIGHBITDEPTH=0 \
  -DCONFIG_WEBM_IO=0 \
  ..
make
make install

print_build_stage libyuv $LIBYUV_SHA
cd $DEPS_SRC/libyuv
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DBUILD_SHARED_LIBS=1 \
  ..
make
make install

print_build_stage libheif $LIBHEIF_VERSION
cd $DEPS_SRC/libheif
# Fix possible memory leak
curl -Ls https://github.com/strukturag/libheif/commit/9f9e084608f4fd38fe6abac85d97a5c7316d44c9.patch | git apply
# libyuv support
curl -Ls https://github.com/DarthSim/libheif/commit/cf4e086f1872b54123ac96efb02a3fdcfbf800fe.patch | git apply
# Set default threads to 1 (works better for highly loaded apps)
sed -i "s/p->integer.default_value = 4/p->integer.default_value = 1/" libheif/plugins/encoder_aom.cc
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  --preset=release-noplugins \
  -DBUILD_SHARED_LIBS=1 \
  -DWITH_EXAMPLES=0 \
  ..
make
make install

print_build_stage gdk-pixbuf $GDKPIXBUF_VERSION
cd $DEPS_SRC/gdk-pixbuf
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG} \
  -Dintrospection=disabled \
  -Dinstalled_tests=false \
  -Dgio_sniffing=false \
  -Dman=false \
  -Dtiff=disabled \
  -Dbuiltin_loaders=png,jpeg
ninja -C _build
ninja -C _build install
rm -rf /usr/local/lib/gdk-pixbuf-2.0

print_build_stage freetype $FREETYPE_VERSION
cd $DEPS_SRC/freetype
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG} \
  -Dzlib=enabled \
  -Dpng=disabled \
  -Dharfbuzz=disabled \
  -Dbrotli=disabled \
  -Dbzip2=disabled
ninja -C _build
ninja -C _build install

print_build_stage fontconfig $FONTCONFIG_VERSION
cd $DEPS_SRC/fontconfig
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-docs
make install-strip

print_build_stage harfbuzz $HARFBUZZ_VERSION
cd $DEPS_SRC/harfbuzz
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  -Dgobject=disabled \
  -Dicu=disabled \
  -Dtests=disabled \
  -Dintrospection=disabled \
  -Ddocs=disabled \
  -Dbenchmark=disabled \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install
rm /usr/local/lib/libharfbuzz-subset*

print_build_stage pixman $PIXMAN_VERSION
cd $DEPS_SRC/pixman
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-arm-iwmmxt
make install-strip

print_build_stage cairo $CAIRO_VERSION
cd $DEPS_SRC/cairo
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  -Dquartz=disabled \
  -Dxcb=disabled \
  -Dxlib=disabled \
  -Dzlib=disabled \
  -Dtests=disabled \
  -Dspectre=disabled \
  -Dsymbol-lookup=disabled \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install

print_build_stage fribidi $FRIBIDI_VERSION
cd $DEPS_SRC/fribidi
autoreconf -fiv
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage pango $PANGO_VERSION
cd $DEPS_SRC/pango
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  -Dgtk_doc=false \
  -Dintrospection=disabled \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install

print_build_stage librsvg $LIBRSVG_VERSION
cd $DEPS_SRC/librsvg
sed -i'.bak' "s/^\(Requires:.*\)/\1 cairo-gobject pangocairo/" librsvg.pc.in
# LTO optimization does not work for staticlib+rlib compilation
sed -i'.bak' "s/, \"rlib\"//" Cargo.toml
# Skip executables
sed -i'.bak' "/SCRIPTS = /d" Makefile.in
RUST_TARGET=$CARGO_TARGET \
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-introspection \
  --disable-tools \
  --disable-pixbuf-loader \
  --disable-nls \
  --without-libiconv-prefix \
  --without-libintl-prefix
make install-strip

print_build_stage vips $VIPS_VERSION
cd $DEPS_SRC/vips
# Speedup premultiply/unpremutiply a bit
curl -Ls https://github.com/libvips/libvips/commit/7eba4ee43fdd0098b7f717d9a5d09a5a7fe6b073.patch | git apply
# Copyless vips_jpegload_buffer
curl -Ls https://github.com/libvips/libvips/commit/e08190f7efa1c510a3e774af2c1dd277076fd152.patch | git apply
curl -Ls https://github.com/libvips/libvips/commit/db1eec430c124d3b0573ee2208246565022e1c36.patch | git apply
# Scan multiple lines at once in jpegload
curl -Ls https://github.com/DarthSim/libvips/commit/479058fbc904abaea6920f7004972e711823cca6.patch | git apply
# Optimize webpsave
curl -Ls https://github.com/DarthSim/libvips/commit/1fa9c41a6c2eb73179abd1ee57babc34a28887bb.patch | git apply
# Change introspection option to feature type (can't apply further patches without this)
curl -Ls https://github.com/libvips/libvips/commit/c0a0630c6bc10420766a6f83adcdd02330fa859d.patch | git apply --exclude=README.md
# Fix signed_fixed_round( 0 )
curl -Ls https://github.com/libvips/libvips/commit/0df1fc51a9cc2a61777d8fba97189f5ceee68511.patch | git apply
# int64_t intermediate for int/uint redice(v/h)
curl -Ls https://github.com/libvips/libvips/commit/8550ae110ba61e69648d9c5313e1686114cb1b06.patch | git apply
# SIMD optimizations for convi, reducev, and reduceh
curl -Ls https://github.com/DarthSim/libvips/commit/603f8fa04ca90982eadcaa108b0eaced6c2e9bd1.patch | git apply
curl -Ls https://github.com/DarthSim/libvips/commit/3ddf2cc743b265adfb041798767ba2f803986011.patch | git apply
# reduce(v/h) without embed
curl -Ls https://github.com/DarthSim/libvips/commit/bcc22de57b1c20bb3bef1c56ec2b9e5903d44b22.patch | git apply
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  -Dgtk_doc=false \
  -Dintrospection=disabled \
  -Dmodules=disabled \
  -Dsimd=true \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install
rm -rf /usr/local/lib/libvips-cpp.*

rm -rf /usr/local/lib/*.a
rm -rf /usr/local/lib/*.la
