#!/bin/bash

set -e

my_dir="$(dirname "$0")"
source "$my_dir/versions.sh"

print_build_stage() {
  echo ""
  echo "== Build $1 $2 ====================================="
  echo ""
}

print_download_stage() {
  echo ""
  echo "== Download $1 $2 =================================="
  echo ""
}

snake_version() {
  echo $1 | sed 's/\./_/g'
}

minor_version() {
  echo "$1" | sed -E 's/^([0-9]+\.[0-9]+).*/\1/'
}

DEPS_SRC=/root/deps
mkdir $DEPS_SRC

#
# DOWNLOAD DEPS ================================================================
#

print_download_stage glib $GLIB_VERSION
mkdir $DEPS_SRC/glib
cd $DEPS_SRC/glib
curl -Lks https://download.gnome.org/sources/glib/$(minor_version $GLIB_VERSION)/glib-${GLIB_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage quantizr $QUANTIZR_VERSION
mkdir $DEPS_SRC/quantizr
cd $DEPS_SRC/quantizr
curl -Ls https://github.com/DarthSim/quantizr/archive/v$QUANTIZR_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage expat $LIBEXPAT_VERSION
mkdir $DEPS_SRC/expat
cd $DEPS_SRC/expat
curl -Ls https://github.com/libexpat/libexpat/releases/download/R_$(snake_version $LIBEXPAT_VERSION)/expat-$LIBEXPAT_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libxml2 $LIBXML2_VERSION
mkdir $DEPS_SRC/libxml2
cd $DEPS_SRC/libxml2
curl -Ls http://xmlsoft.org/sources/libxml2-${LIBXML2_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libexif $LIBEXIF_VERSION
mkdir $DEPS_SRC/libexif
cd $DEPS_SRC/libexif
curl -Ls https://github.com/libexif/libexif/archive/libexif-$(snake_version $LIBEXIF_VERSION)-release.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage lcms2 $LCMS2_VERSION
mkdir $DEPS_SRC/lcms2
cd $DEPS_SRC/lcms2
curl -Ls https://sourceforge.net/projects/lcms/files/lcms/$LCMS2_VERSION/lcms2-$LCMS2_VERSION.tar.gz/download \
  | tar -xzC . --strip-components=1

print_download_stage libjpeg-turbo $LIBJPEGTURBO_VERSION
mkdir $DEPS_SRC/libjpeg-turbo
cd $DEPS_SRC/libjpeg-turbo
curl -Ls https://github.com/libjpeg-turbo/libjpeg-turbo/archive/$LIBJPEGTURBO_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libpng $LIBPNG_VERSION
mkdir $DEPS_SRC/libpng
cd $DEPS_SRC/libpng
curl -Ls https://sourceforge.net/projects/libpng/files/libpng16/$LIBPNG_VERSION/libpng-$LIBPNG_VERSION.tar.gz/download \
  | tar -xzC . --strip-components=1

print_download_stage giflib $GIFLIB_VERSION
mkdir $DEPS_SRC/giflib
cd $DEPS_SRC/giflib
curl -Ls https://sourceforge.net/projects/giflib/files/giflib-$GIFLIB_VERSION.tar.gz/download \
  | tar -xzC . --strip-components=1

print_download_stage libwebp $LIBWEBP_VERSION
mkdir $DEPS_SRC/libwebp
cd $DEPS_SRC/libwebp
curl -Ls https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-$LIBWEBP_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libtiff $LIBTIFF_VERSION
mkdir $DEPS_SRC/libtiff
cd $DEPS_SRC/libtiff
curl -Ls https://gitlab.com/libtiff/libtiff/-/archive/v$LIBTIFF_VERSION/libtiff-v$LIBTIFF_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libde265 $LIBDE265_VERSION
mkdir $DEPS_SRC/libde265
cd $DEPS_SRC/libde265
curl -Ls https://github.com/strukturag/libde265/releases/download/v$LIBDE265_VERSION/libde265-$LIBDE265_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage dav1d $DAV1D_VERSION
mkdir $DEPS_SRC/dav1d
cd $DEPS_SRC/dav1d
curl -Ls https://code.videolan.org/videolan/dav1d/-/archive/$DAV1D_VERSION/dav1d-$DAV1D_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage rav1e $RAV1E_VERSION
mkdir $DEPS_SRC/rav1e
cd $DEPS_SRC/rav1e
curl -Ls https://github.com/xiph/rav1e/archive/v$RAV1E_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libheif $LIBHEIF_VERSION
mkdir $DEPS_SRC/libheif
cd $DEPS_SRC/libheif
curl -Ls https://github.com/strukturag/libheif/releases/download/v$LIBHEIF_VERSION/libheif-$LIBHEIF_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage gdk-pixbuf $GDKPIXBUF_VERSION
mkdir $DEPS_SRC/gdk-pixbuf
cd $DEPS_SRC/gdk-pixbuf
curl -Lks https://download.gnome.org/sources/gdk-pixbuf/$(minor_version $GDKPIXBUF_VERSION)/gdk-pixbuf-${GDKPIXBUF_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage freetype $FREETYPE_VERSION
mkdir $DEPS_SRC/freetype
cd $DEPS_SRC/freetype
curl -Ls https://download.savannah.gnu.org/releases/freetype/freetype-${FREETYPE_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage fontconfig $FONTCONFIG_VERSION
mkdir $DEPS_SRC/fontconfig
cd $DEPS_SRC/fontconfig
curl -Ls https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage harfbuzz $HARFBUZZ_VERSION
mkdir $DEPS_SRC/harfbuzz
cd $DEPS_SRC/harfbuzz
curl -Ls https://github.com/harfbuzz/harfbuzz/archive/${HARFBUZZ_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage pixman $PIXMAN_VERSION
mkdir $DEPS_SRC/pixman
cd $DEPS_SRC/pixman
curl -Ls https://cairographics.org/releases/pixman-${PIXMAN_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage cairo $CAIRO_VERSION
mkdir $DEPS_SRC/cairo
cd $DEPS_SRC/cairo
curl -Ls https://cairographics.org/releases/cairo-${CAIRO_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage fribidi $FRIBIDI_VERSION
mkdir $DEPS_SRC/fribidi
cd $DEPS_SRC/fribidi
curl -Ls https://github.com/fribidi/fribidi/releases/download/v${FRIBIDI_VERSION}/fribidi-${FRIBIDI_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage pango $PANGO_VERSION
mkdir $DEPS_SRC/pango
cd $DEPS_SRC/pango
curl -Lks https://download.gnome.org/sources/pango/$(minor_version $PANGO_VERSION)/pango-${PANGO_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage libcroco $LIBCROCO_VERSION
mkdir $DEPS_SRC/libcroco
cd $DEPS_SRC/libcroco
curl -Ls https://download.gnome.org/sources/libcroco/$(minor_version $LIBCROCO_VERSION)/libcroco-$LIBCROCO_VERSION.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage librsvg $LIBRSVG_VERSION
mkdir $DEPS_SRC/librsvg
cd $DEPS_SRC/librsvg
curl -Lks https://download.gnome.org/sources/librsvg/$(minor_version $LIBRSVG_VERSION)/librsvg-${LIBRSVG_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage ImageMagick $IMAGEMAGICK_VERSION
mkdir $DEPS_SRC/ImageMagick
cd $DEPS_SRC/ImageMagick
curl -Ls https://github.com/ImageMagick/ImageMagick/archive/$IMAGEMAGICK_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage vips $VIPS_VERSION
mkdir $DEPS_SRC/vips
cd $DEPS_SRC/vips
curl -Ls https://github.com/libvips/libvips/releases/download/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

#
# BUILD DEPS ===================================================================
#

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

print_build_stage giflib $GIFLIB_VERSION
cd $DEPS_SRC/giflib
make PREFIX=/usr/local install

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
# Patch cmake to use pkg-config for rav1e and dav1d
patch -p1 < /root/libheif.patch
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
  -Dintrospection=false
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
