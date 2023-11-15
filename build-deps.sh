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
make install/strip -j$(nproc)

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
make install-strip -j$(nproc)

print_build_stage glib $GLIB_VERSION
cd $DEPS_SRC/glib
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG} \
  -Dlibmount=disabled \
  -Dtests=false \
  -Dinstalled_tests=false
ninja -C _build
ninja -C _build install

print_build_stage highway $HIGHWAY_VERSION
cd $DEPS_SRC/highway
mkdir _build
cd _build
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DBUILD_SHARED_LIBS=TRUE \
  -DHWY_ENABLE_EXAMPLES=FALSE \
  -DHWY_ENABLE_TESTS=FALSE \
  ..
make -j$(nproc)
make install/strip

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
make install -j$(nproc)

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
make install-strip -j$(nproc)

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
make install-strip -j$(nproc)

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
make install-strip -j$(nproc)

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
make install/strip -j$(nproc)

print_build_stage libpng $LIBPNG_VERSION
cd $DEPS_SRC/libpng
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)

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
make install-strip -j$(nproc)

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
make -j$(nproc)
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
make install-strip -j$(nproc)

print_build_stage kvazaar $KVAZAAR_VERSION
cd $DEPS_SRC/kvazaar
# Disable redundant logging
curl -Ls https://github.com/ultravideo/kvazaar/commit/580c6e27586d82394b1912ea1ef9932f8572a59d.patch | git apply
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static
make install-strip -j$(nproc)

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
  -DCONFIG_WEBM_IO=0 \
  ..
make -j$(nproc)
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
make -j$(nproc)
make install

print_build_stage libheif $LIBHEIF_VERSION
cd $DEPS_SRC/libheif
# libyuv support
curl -Ls https://github.com/DarthSim/libheif/commit/7a5e9a8f88c93bf8f2d32e035b0227f2feef2ab7.patch | git apply
# kvaazar: set chroma in kvazaar_query_input_colorspace2
curl -Ls https://github.com/DarthSim/libheif/commit/0d6f1d935bafa3727a29bf25f9df164cb6c65814.patch | git apply
# fix kvazaar encoding with odd image sizes
curl -Ls https://github.com/DarthSim/libheif/commit/8f2cc0a09993cb9efddfe6250a7e5ee606326648.patch | git apply
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
  -DWITH_KVAZAAR=1 \
  -DWITH_DAV1D=1 \
  -DWITH_AOM_DECODER=0 \
  ..
make -j$(nproc)
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
  -Dbuiltin_loaders=png,jpeg,gif
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
make install-strip -j$(nproc)

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
make install-strip -j$(nproc)

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
make install-strip -j$(nproc)

print_build_stage pango $PANGO_VERSION
cd $DEPS_SRC/pango
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  -Dgtk_doc=false \
  -Dintrospection=disabled \
  -Dfontconfig=enabled \
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
make install-strip -j$(nproc)

print_build_stage vips $VIPS_VERSION
cd $DEPS_SRC/vips
# Speedup premultiply/unpremutiply a bit
curl -Ls https://github.com/DarthSim/libvips/commit/7d35d045933cde120f60dd0e98ab42437e91b98e.patch | git apply
# Copyless vips_jpegload_buffer
curl -Ls https://github.com/DarthSim/libvips/commit/c9f50f917aac4c62b9b288de77651037dce78941.patch | git apply
curl -Ls https://github.com/DarthSim/libvips/commit/1ab7f72ad723cca0964ba8134bd0b68b0e3fe446.patch | git apply
# Scan multiple lines at once in jpegload
curl -Ls https://github.com/DarthSim/libvips/commit/1a6dbfeb5ea4099e99d356294eabf238d17228b9.patch | git apply
# Optimize webpsave
curl -Ls https://github.com/DarthSim/libvips/commit/650b3258b221126c27915320d70303a9656a743c.patch | git apply
# Fix signed_fixed_round( 0 )
curl -Ls https://github.com/DarthSim/libvips/commit/3d1ba235be21f33badeff94949a0cd449f9935a4.patch | git apply
# int64_t intermediate for int/uint redice(v/h)
curl -Ls https://github.com/DarthSim/libvips/commit/945be865cb39bba6e03edca0a1bfd14a16ca2b0e.patch | git apply
# Aligned image buffers
curl -Ls https://github.com/DarthSim/libvips/commit/71dd1a75ddc70f66c47884d021fb11498b1107e8.patch | git apply
curl -Ls https://github.com/DarthSim/libvips/commit/290ff27989fab738d1afb16ab12cb92c49969018.patch | git apply
# SIMD optimizations for convi, reducev, and reduceh
curl -Ls https://github.com/DarthSim/libvips/commit/5b27fa725908ef6a819fb320017aec7845dbb3a9.patch | git apply
curl -Ls https://github.com/DarthSim/libvips/commit/d436a527530206b3edd61ea26cebc79c5de5283e.patch | git apply
# reduce(v/h) without embed
curl -Ls https://github.com/DarthSim/libvips/commit/e9676d3020d7d09bd74b3cfad3fbe10207f5193e.patch | git apply
# Fix invalid UTF-8 strings instead of ignoring them
curl -Ls https://github.com/DarthSim/libvips/commit/d09c4509d28e6dc5c8c4088212494e03278ad515.patch | git apply
# tiffload: add 16-bit float support
curl -Ls https://github.com/DarthSim/libvips/commit/cbdfc48c1c7cb2ac4f5dea33bc2e702b5ed9f5db.patch | git apply
# tiffload: use TIFFRGBAImage or TIFFReadRGBATile if tiff image type is not natively supported by libvips
curl -Ls https://github.com/DarthSim/libvips/commit/8f51ade2ac9e8450058d2e6e0d1a3099f385145d.patch | git apply
# Fix saving EXIF strings with invalid UTF8 encoding
curl -Ls https://github.com/DarthSim/libvips/commit/dfe65aa3c2d2bc786648577fc906430376b8f2f0.patch | git apply
# heifload: don't allocate meta/ICC memory as local to out
curl -Ls https://github.com/DarthSim/libvips/commit/967334684208a98630d76038b91b68b2430b708c.patch | git apply
# call heif_init on heif startup
curl -Ls https://github.com/DarthSim/libvips/commit/04d3755b0433fb1b0fc988261713780f9656b9e8.patch | git apply
# heifsave: errors must have a message in libheif 1.17.0+
curl -Ls https://github.com/DarthSim/libvips/commit/43933c7a992af2b487c175b3e91f71b003eed34c.patch | git apply
# heifsave: set default nclx profile if ICC profile is not provided
curl -Ls https://github.com/DarthSim/libvips/commit/01b3c52e540570259aac9fd8ee42b04874eb4bac.patch | git apply
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  -Dgtk_doc=false \
  -Dintrospection=false \
  -Dmodules=disabled \
  -Dsimd=true \
  ${MESON_CROSS_CONFIG}
ninja -C _build
ninja -C _build install
rm -rf /usr/local/lib/libvips-cpp.*

rm -rf /usr/local/lib/*.a
rm -rf /usr/local/lib/*.la
