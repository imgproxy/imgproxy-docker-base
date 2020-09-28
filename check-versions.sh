#!/bin/bash
set -e

my_dir="$(dirname "$0")"
source "$my_dir/versions.sh"

all_latest=yes

check_version() {
  version=$(curl -s https://release-monitoring.org/api/project/$3  | jq -r '.versions[]' | grep -E -m1 "^[0-9]+(\.[0-9]+)*(\-[0-9]+)?$")
  if [ "$version" != "$2" ]; then
    all_latest=no
    echo "$1. Latest version: $version. Current version: $2"
  fi
}

check_version "GLIB" $GLIB_VERSION "10024"
# check_version "QUANTIZR" $QUANTIZR_VERSION ""
check_version "LIBEXPAT" $LIBEXPAT_VERSION "770"
check_version "LIBXML2" $LIBXML2_VERSION "1783"
check_version "LIBEXIF" $LIBEXIF_VERSION "1607"
check_version "LCMS2" $LCMS2_VERSION "9815"
check_version "LIBJPEGTURBO" $LIBJPEGTURBO_VERSION "1648"
check_version "LIBPNG" $LIBPNG_VERSION "15294"
check_version "GIFLIB" $GIFLIB_VERSION "1158"
check_version "LIBWEBP" $LIBWEBP_VERSION "1761"
check_version "LIBTIFF" $LIBTIFF_VERSION "13521"
check_version "LIBDE265" $LIBDE265_VERSION "11239"
check_version "RAV1E" $RAV1E_VERSION "75048"
check_version "LIBHEIF" $LIBHEIF_VERSION "64439"
check_version "GDKPIXBUF" $GDKPIXBUF_VERSION "9533"
check_version "FREETYPE" $FREETYPE_VERSION "854"
check_version "FONTCONFIG" $FONTCONFIG_VERSION "827"
check_version "HARFBUZZ" $HARFBUZZ_VERSION "1299"
check_version "PIXMAN" $PIXMAN_VERSION "3648"
# check_version "CAIRO" $CAIRO_VERSION "247"
check_version "FRIBIDI" $FRIBIDI_VERSION "857"
check_version "LIBCROCO" $LIBCROCO_VERSION "11787"
check_version "PANGO" $PANGO_VERSION "11783"
check_version "LIBRSVG" $LIBRSVG_VERSION "5420"
check_version "IMAGEMAGICK" $IMAGEMAGICK_VERSION "1372"
check_version "VIPS" $VIPS_VERSION "5097"

libaom_latest_version=$(git ls-remote -t https://aomedia.googlesource.com/aom.git | grep -E 'refs/tags/v\d+\.\d+\.\d+$' | awk '{print $2}' | sed -e "s/refs\/tags\/v//" | tail -1)
if [ "$libaom_latest_version" != "$LIBAOM_VERSION" ]; then
  all_latest=no
  echo "LIBAOM. Latest version: $libaom_latest_version. Current version: $LIBAOM_VERSION"
fi

if [ "$all_latest" = "no" ]; then exit 1; fi
