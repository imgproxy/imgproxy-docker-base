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

print_build_stage glib $GLIB_VERSION
cd $DEPS_SRC/glib
meson setup _build \
  --buildtype=release \
  --strip \
  --prefix=/usr/local \
  --libdir=lib \
  ${MESON_CROSS_CONFIG} \
  -Dinternal_pcre=true \
  -Dlibmount=disabled
ninja -C _build
ninja -C _build install

print_build_stage quantizr $QUANTIZR_VERSION
cd $DEPS_SRC/quantizr
# TODO: Implement proper cross-compile
QUANTIZR_BUILD_DIR=${QUANTIZR_BUILD_DIR:-target/release}
mkdir .cargo
echo $QUANTIZR_CARGO_CONFIG > .cargo/config
./configure \
  --prefix=/usr/local \
  --enable-imagequant-compatibility
make
make BUILD_DIR=$QUANTIZR_BUILD_DIR install

print_build_stage expat $LIBEXPAT_VERSION
cd $DEPS_SRC/expat
./configure \
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
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage lcms2 $LCMS2_VERSION
cd $DEPS_SRC/lcms2
./configure \
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
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DENABLE_SHARED=TRUE \
  -DENABLE_STATIC=FALSE \
  -DWITH_TURBOJPEG=FALSE \
  .
make install/strip

print_build_stage libpng $LIBPNG_VERSION
cd $DEPS_SRC/libpng
./configure \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage libwebp $LIBWEBP_VERSION
cd $DEPS_SRC/libwebp
./configure \
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
cmake .
make
make install

print_build_stage libde265 $LIBDE265_VERSION
cd $DEPS_SRC/libde265
./configure \
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

print_build_stage rav1e $RAV1E_VERSION
cd $DEPS_SRC/rav1e
cargo cinstall --release --library-type=cdylib

print_build_stage libheif $LIBHEIF_VERSION
cd $DEPS_SRC/libheif
mkdir _build
cd _build
cmake \
  -G"Unix Makefiles" \
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
  -Dx11=false \
  -Dgir=false \
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
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-arm-iwmmxt
make install-strip

print_build_stage cairo $CAIRO_VERSION
cd $DEPS_SRC/cairo
./configure \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-xlib \
  --disable-xcb \
  --disable-quartz \
  --disable-win32 \
  --disable-egl \
  --disable-glx \
  --disable-wgl \
  --disable-ps \
  --disable-trace \
  --disable-interpreter
make install-strip

print_build_stage fribidi $FRIBIDI_VERSION
cd $DEPS_SRC/fribidi
autoreconf -fiv
./configure \
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
  ${MESON_CROSS_CONFIG} \
  -Dgtk_doc=false \
  -Dintrospection=disabled
ninja -C _build
ninja -C _build install

print_build_stage libcroco $LIBCROCO_VERSION
cd $DEPS_SRC/libcroco
./configure \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip

print_build_stage librsvg $LIBRSVG_VERSION
cd $DEPS_SRC/librsvg
patch -p1 < /root/librsvg.patch
./configure \
  --build="x86_64-linux-gnu" \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-introspection \
  --disable-tools \
  --disable-pixbuf-loader
make install-strip

print_build_stage ImageMagick $IMAGEMAGICK_VERSION
cd $DEPS_SRC/ImageMagick
./configure \
  --host=$HOST \
  --prefix=/usr/local \
  --enable-silent-rules \
  --disable-static \
  --disable-openmp \
  --disable-deprecated \
  --disable-docs \
  --with-threads \
  --without-magick-plus-plus \
  --without-utilities \
  --without-perl \
  --without-bzlib \
  --without-dps \
  --without-freetype \
  --without-fontconfig \
  --without-jbig \
  --without-jpeg \
  --without-lcms \
  --without-lzma \
  --without-png \
  --without-tiff \
  --without-wmf \
  --without-xml \
  --without-webp \
  --without-heic \
  --without-pango
make install-strip
rm -rf /usr/local/lib/libMagickWand-7.*

print_build_stage vips $VIPS_VERSION
cd $DEPS_SRC/vips
./configure \
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

rm -rf $DEPS_SRC
rm -rf /usr/local/lib/*.a
rm -rf /usr/local/lib/*.la
