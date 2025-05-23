#!/bin/bash

set -e

my_dir="$(dirname "$0")"
source "$my_dir/versions.sh"

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
mkdir -p $DEPS_SRC

print_download_stage zlib $ZLIB_VERSION
mkdir $DEPS_SRC/zlib
cd $DEPS_SRC/zlib
curl -Lks https://github.com/zlib-ng/zlib-ng/archive/${ZLIB_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage brotli $BROTLI_VERSION
mkdir $DEPS_SRC/brotli
cd $DEPS_SRC/brotli
curl -Lks https://github.com/google/brotli/archive/refs/tags/v$BROTLI_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage ffi $FFI_VERSION
mkdir $DEPS_SRC/ffi
cd $DEPS_SRC/ffi
curl -Lks https://github.com/libffi/libffi/releases/download/v${FFI_VERSION}/libffi-${FFI_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage glib $GLIB_VERSION
mkdir $DEPS_SRC/glib
cd $DEPS_SRC/glib
curl -Lks https://download.gnome.org/sources/glib/$(minor_version $GLIB_VERSION)/glib-${GLIB_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage highway $HIGHWAY_VERSION
mkdir $DEPS_SRC/highway
cd $DEPS_SRC/highway
curl -Lks https://github.com/google/highway/archive/refs/tags/$HIGHWAY_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

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
curl -Ls https://download.gnome.org/sources/libxml2/$(minor_version $LIBXML2_VERSION)/libxml2-${LIBXML2_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage libexif $LIBEXIF_VERSION
mkdir $DEPS_SRC/libexif
cd $DEPS_SRC/libexif
curl -Ls https://github.com/libexif/libexif/archive/libexif-$(snake_version $LIBEXIF_VERSION)-release.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage lcms2 $LCMS2_VERSION
mkdir $DEPS_SRC/lcms2
cd $DEPS_SRC/lcms2
curl -Ls https://github.com/mm2/Little-CMS/releases/download/lcms${LCMS2_VERSION}/lcms2-${LCMS2_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libjpeg-turbo $LIBJPEGTURBO_VERSION
mkdir $DEPS_SRC/libjpeg-turbo
cd $DEPS_SRC/libjpeg-turbo
curl -Ls https://github.com/libjpeg-turbo/libjpeg-turbo/archive/$LIBJPEGTURBO_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libjxl $LIBJXL_VERSION
mkdir $DEPS_SRC/libjxl
cd $DEPS_SRC/libjxl
curl -Ls https://github.com/libjxl/libjxl/archive/refs/tags/v$LIBJXL_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libpng $LIBPNG_VERSION
mkdir $DEPS_SRC/libpng
cd $DEPS_SRC/libpng
curl -Ls https://sourceforge.net/projects/libpng/files/libpng16/$LIBPNG_VERSION/libpng-$LIBPNG_VERSION.tar.gz/download \
  | tar -xzC . --strip-components=1

print_download_stage libspng $LIBSPNG_VERSION
mkdir $DEPS_SRC/libspng
cd $DEPS_SRC/libspng
curl -Ls https://github.com/randy408/libspng/archive/refs/tags/v$LIBSPNG_VERSION.tar.gz \
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

print_download_stage cgif $CGIF_VERSION
mkdir $DEPS_SRC/cgif
cd $DEPS_SRC/cgif
curl -Ls https://github.com/dloebl/cgif/archive/refs/tags/v$CGIF_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libde265 $LIBDE265_VERSION
mkdir $DEPS_SRC/libde265
cd $DEPS_SRC/libde265
curl -Ls https://github.com/strukturag/libde265/releases/download/v$LIBDE265_VERSION/libde265-$LIBDE265_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage kvazaar $KVAZAAR_VERSION
mkdir $DEPS_SRC/kvazaar
cd $DEPS_SRC/kvazaar
curl -Ls https://github.com/ultravideo/kvazaar/releases/download/v$KVAZAAR_VERSION/kvazaar-$KVAZAAR_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage dav1d $DAV1D_VERSION
mkdir $DEPS_SRC/dav1d
cd $DEPS_SRC/dav1d
curl -Ls https://code.videolan.org/videolan/dav1d/-/archive/$DAV1D_VERSION/dav1d-$DAV1D_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

# print_download_stage rav1e $RAV1E_VERSION
# mkdir $DEPS_SRC/rav1e
# cd $DEPS_SRC/rav1e
# curl -Ls https://github.com/xiph/rav1e/archive/v$RAV1E_VERSION.tar.gz \
#   | tar -xzC . --strip-components=1

print_download_stage aom $AOM_VERSION
mkdir $DEPS_SRC/aom
cd $DEPS_SRC/aom
curl -Ls https://storage.googleapis.com/aom-releases/libaom-${AOM_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage libyuv $LIBYUV_SHA
mkdir $DEPS_SRC/libyuv
cd $DEPS_SRC/libyuv
curl -Ls https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_SHA}.tar.gz \
  | tar -xzC .

print_download_stage libheif $LIBHEIF_VERSION
mkdir $DEPS_SRC/libheif
cd $DEPS_SRC/libheif
curl -Ls https://github.com/strukturag/libheif/releases/download/v$LIBHEIF_VERSION/libheif-$LIBHEIF_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

print_download_stage freetype $FREETYPE_VERSION
mkdir $DEPS_SRC/freetype
cd $DEPS_SRC/freetype
curl -Ls https://gitlab.freedesktop.org/freetype/freetype/-/archive/VER-${FREETYPE_VERSION//./-}/freetype-VER-${FREETYPE_VERSION//./-}.tar.bz2 \
  | tar -xjC . --strip-components=1

print_download_stage fontconfig $FONTCONFIG_VERSION
mkdir $DEPS_SRC/fontconfig
cd $DEPS_SRC/fontconfig
curl -Ls https://gitlab.freedesktop.org/fontconfig/fontconfig/-/archive/${FONTCONFIG_VERSION}/fontconfig-${FONTCONFIG_VERSION}.tar.gz \
  | tar -xzC . --strip-components=1

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
curl -Ls https://gitlab.freedesktop.org/cairo/cairo/-/archive/$CAIRO_VERSION/cairo-$CAIRO_VERSION.tar.gz \
  | tar -xzC . --strip-components=1

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

print_download_stage librsvg $LIBRSVG_VERSION
mkdir $DEPS_SRC/librsvg
cd $DEPS_SRC/librsvg
curl -Lks https://download.gnome.org/sources/librsvg/$(minor_version $LIBRSVG_VERSION)/librsvg-${LIBRSVG_VERSION}.tar.xz \
  | tar -xJC . --strip-components=1

print_download_stage vips $VIPS_VERSION
mkdir $DEPS_SRC/vips
cd $DEPS_SRC/vips
curl -Ls https://github.com/libvips/libvips/releases/download/v$VIPS_VERSION/vips-$VIPS_VERSION.tar.xz \
  | tar -xJC . --strip-components=1
