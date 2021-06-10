#!/bin/bash
set -e

my_dir="$(dirname "$0")"
versions_file="$my_dir/versions.sh"
source $versions_file

version_entry() {
  echo "export $1_VERSION=$2"
}

check_version() {
  name=$1
  old_version=$2
  new_version=$(curl -s https://release-monitoring.org/api/project/$3  | jq -r '.versions[]' | grep -E -m1 "^[0-9]+(\.[0-9]+)*(\-[0-9]+)?$")

  if [ "$new_version" != "$old_version" ]; then
    old_entry=$(version_entry $name $old_version)
    new_entry=$(version_entry $name $new_version)
    sed -i '' "s/$old_entry/$new_entry/g" "$versions_file"
    echo "$name. Latest version: $new_version. Current version: $old_version"
  fi
}

check_version "GOLANG" $GOLANG_VERSION "1227"
check_version "GLIB" $GLIB_VERSION "10024"
# check_version "QUANTIZR" $QUANTIZR_VERSION ""
check_version "LIBEXPAT" $LIBEXPAT_VERSION "770"
check_version "LIBXML2" $LIBXML2_VERSION "1783"
check_version "LIBEXIF" $LIBEXIF_VERSION "1607"
check_version "LCMS2" $LCMS2_VERSION "9815"
check_version "LIBJPEGTURBO" $LIBJPEGTURBO_VERSION "1648"
check_version "LIBPNG" $LIBPNG_VERSION "15294"
check_version "LIBWEBP" $LIBWEBP_VERSION "1761"
check_version "LIBTIFF" $LIBTIFF_VERSION "1738"
check_version "LIBDE265" $LIBDE265_VERSION "11239"
check_version "DAV1D" $DAV1D_VERSION "18920"
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
# New librsvg releases are experimental
# check_version "LIBRSVG" $LIBRSVG_VERSION "5420"
check_version "IMAGEMAGICK" $IMAGEMAGICK_VERSION "1372"
check_version "VIPS" $VIPS_VERSION "5097"
