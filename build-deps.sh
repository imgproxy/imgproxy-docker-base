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
cp /usr/local/lib/pkgconfig/quantizr.pc /usr/local/lib/pkgconfig/imagequant.pc
cp /usr/local/include/quantizr/quantizr.h /usr/local/include/quantizr/libimagequant.h

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
  --without-python \
  --without-debug \
  --without-docbook \
  --without-ftp \
  --without-html \
  --without-legacy \
  --without-push \
  --without-schematron
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
  -DENABLE_SHARED=TRUE \
  -DENABLE_STATIC=FALSE \
  .
make
make install

print_build_stage cgif $CGIF_VERSION
cd $DEPS_SRC/cgif
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
cmake \
  -G"Unix Makefiles" \
  $AOM_FLAGS \
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
  -DCONFIG_AV1_DECODER=0 \
  ..
make
make install

print_build_stage libheif $LIBHEIF_VERSION
cd $DEPS_SRC/libheif
mkdir _build
cd _build
cmake \
  -G"Unix Makefiles" \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=$CMAKE_SYSTEM_PROCESSOR \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
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
  -Dbuiltin_loaders=png,jpeg,tiff
ninja -C _build
ninja -C _build install
rm -rf /usr/local/lib/gdk-pixbuf-2.0

print_build_stage freetype $FREETYPE_VERSION
cd $DEPS_SRC/freetype
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --without-bzip2
make install

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

print_build_stage libcroco $LIBCROCO_VERSION
cd $DEPS_SRC/libcroco
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage librsvg $LIBRSVG_VERSION
cd $DEPS_SRC/librsvg
# [PATCH] (#859): Make rst2man and gi-docgen optional
curl -Ls https://gitlab.gnome.org/GNOME/librsvg/-/commit/8eccd72a6b07f624768e734d3eadc3a1cde14f47.patch | patch -p1
autoreconf -fiv
sed -i'.bak' "s/^\(Requires:.*\)/\1 cairo-gobject pangocairo/" librsvg.pc.in
# LTO optimization does not work for staticlib+rlib compilation
sed -i'.bak' "s/, \"rlib\"//" Cargo.toml
# Skip executables
sed -i'.bak' "/SCRIPTS = /d" Makefile.in
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
# Fix failing on too many text chunks in PNGs
patch -p1 < /root/libvips-png-dont-fail-on-text-chunks.patch
# Fix loading of some GIFs
sed -i 's/(res == LZW_OK_EOD)/(res == LZW_OK_EOD || res == LZW_EOI_CODE)/' libvips/foreign/libnsgif/libnsgif.c
./configure \
  --build=$BUILD \
  --host=$HOST \
  --prefix=/usr/local \
  --without-python \
  --without-OpenEXR \
  --enable-debug=no \
  --disable-static \
  --disable-introspection \
  --enable-silent-rules
make install-strip
rm -rf /usr/local/lib/libvips-cpp.*

rm -rf /usr/local/lib/*.a
rm -rf /usr/local/lib/*.la
