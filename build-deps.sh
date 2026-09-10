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

TARGET_PATH=/opt/imgproxy
mkdir -p $TARGET_PATH

export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
export CARGO_PROFILE_RELEASE_LTO=true

# Function to add Software Bill of Materials (SBOM) for a dependency.
# Arguments:
#   $1 - name of the dependency.
#   $2 - version of the dependency.
#   $3 - CPE (Common Platform Enumeration) of the dependency.
#
# You can find CPEs at https://nvd.nist.gov/products/cpe/search/
# or with `grype db search <name>`.
add_sbom() {
  local name=$1
  local version=$2
  local cpe=$3

  local filename="$TARGET_PATH/share/sbom/$name.cdx.json"

  mkdir -p $(dirname $filename)
  cat << EOF > $filename
{
  "\$schema": "https://cyclonedx.org/schema/bom-1.7.schema.json",
  "bomFormat": "CycloneDX",
  "specVersion": "1.7",
  "version": 1,
  "metadata": {
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "component": {
      "type": "library",
      "name": "$name",
      "version": "$version",
      "cpe": "$cpe",
      "properties": [
        { "name": "syft:package:type", "value": "binary" }
      ]
    }
  }
}
EOF

  echo "SBOM for $name $version added to $filename"
}

print_build_stage zlib $ZLIB_VERSION
cd $DEPS_SRC/zlib
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DBUILD_SHARED_LIBS=TRUE \
  -DZLIB_COMPAT=TRUE \
  -DWITH_ARMV6=FALSE \
  -DWITH_GTEST=FALSE \
  ..
ninja install/strip
add_sbom "zlib-ng" $ZLIB_VERSION \
  "cpe:2.3:a:zlib-ng:zlib-ng:$ZLIB_VERSION:*:*:*:*:*:*:*"

print_build_stage brotli $BROTLI_VERSION
cd $DEPS_SRC/brotli
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DBUILD_SHARED_LIBS=TRUE \
  -DBROTLI_DISABLE_TESTS=TRUE \
  ..
ninja install/strip
add_sbom "brotli" $BROTLI_VERSION \
  "cpe:2.3:a:google:brotli:$BROTLI_VERSION:*:*:*:*:*:*:*"

print_build_stage ffi $FFI_VERSION
cd $DEPS_SRC/ffi
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --disable-builddir \
  --disable-multi-os-directory \
  --disable-raw-api
make install-strip -j$(nproc)
add_sbom "ffi" $FFI_VERSION \
  "cpe:2.3:a:libffi_project:libffi:$FFI_VERSION:*:*:*:*:*:*:*"

print_build_stage pcre2 $PCRE2_VERSION
cd $DEPS_SRC/pcre2
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DBUILD_SHARED_LIBS=TRUE \
  -DBUILD_STATIC_LIBS=OFF \
  -DPCRE2_SUPPORT_JIT=ON \
  ..
ninja install/strip
add_sbom "pcre2" $PCRE2_VERSION \
  "cpe:2.3:a:pcre:pcre2:$PCRE2_VERSION:*:*:*:*:*:*:*"

print_build_stage glib $GLIB_VERSION
cd $DEPS_SRC/glib
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dlibmount=disabled \
  -Dtests=false \
  -Dintrospection=disabled \
  -Dnls=disabled \
  -Dsysprof=disabled \
  -Dlibelf=disabled \
  -Dinstalled_tests=false \
  -Dglib_debug=disabled
ninja -C _build
ninja -C _build install
add_sbom "glib" $GLIB_VERSION \
  "cpe:2.3:a:gnome:glib:$GLIB_VERSION:*:*:*:*:*:*:*"

print_build_stage highway $HIGHWAY_VERSION
cd $DEPS_SRC/highway
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DBUILD_SHARED_LIBS=TRUE \
  -DHWY_ENABLE_EXAMPLES=FALSE \
  -DHWY_ENABLE_TESTS=FALSE \
  -DHWY_ENABLE_CONTRIB=FALSE \
  ..
ninja install/strip
add_sbom "highway" $HIGHWAY_VERSION \
  "cpe:2.3:a:google:highway:$HIGHWAY_VERSION:*:*:*:*:*:*:*"

print_build_stage quantizr $QUANTIZR_VERSION
cd $DEPS_SRC/quantizr
cargo cinstall \
  --release \
  --library-type=cdylib \
  --prefix=$TARGET_PATH \
  --libdir=$TARGET_PATH/lib
add_sbom "quantizr" $QUANTIZR_VERSION \
  "cpe:2.3:a:darthsim:quantizr:$QUANTIZR_VERSION:*:*:*:*:*:*:*"

print_build_stage expat $LIBEXPAT_VERSION
cd $DEPS_SRC/expat
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --without-xmlwf
make install -j$(nproc)
add_sbom "expat" $LIBEXPAT_VERSION \
  "cpe:2.3:a:libexpat_project:libexpat:$LIBEXPAT_VERSION:*:*:*:*:*:*:*"

print_build_stage libxml2 $LIBXML2_VERSION
cd $DEPS_SRC/libxml2
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dminimum=true
ninja -C _build
ninja -C _build install
add_sbom "libxml2" $LIBXML2_VERSION \
  "cpe:2.3:a:xmlsoft:libxml2:$LIBXML2_VERSION:*:*:*:*:*:*:*"

print_build_stage libexif $LIBEXIF_VERSION
cd $DEPS_SRC/libexif
autoreconf -i
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)
add_sbom "libexif" $LIBEXIF_VERSION \
  "cpe:2.3:a:libexif_project:libexif:$LIBEXIF_VERSION:*:*:*:*:*:*:*"

print_build_stage lcms2 $LCMS2_VERSION
cd $DEPS_SRC/lcms2
CFLAGS="${CFLAGS} -O3" \
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)
add_sbom "lcms2" $LCMS2_VERSION \
  "cpe:2.3:a:littlecms:little_cms_color_engine:$LCMS2_VERSION:*:*:*:*:*:*:*"

print_build_stage libjpeg-turbo $LIBJPEGTURBO_VERSION
cd $DEPS_SRC/libjpeg-turbo
mkdir _build
cd _build
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DENABLE_SHARED=TRUE \
  -DENABLE_STATIC=FALSE \
  -DWITH_TURBOJPEG=FALSE \
  -DWITH_JPEG8=1 \
  -DPNG_SUPPORTED=FALSE \
  ..
ninja install/strip
add_sbom "libjpeg-turbo" $LIBJPEGTURBO_VERSION \
  "cpe:2.3:a:libjpeg-turbo:libjpeg-turbo:$LIBJPEGTURBO_VERSION:*:*:*:*:*:*:*"

print_build_stage libjxl $LIBJXL_VERSION
cd $DEPS_SRC/libjxl
mkdir _build
cd _build
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DJPEGXL_STATIC=FALSE \
  -DBUILD_TESTING=OFF \
  -DJPEGXL_ENABLE_FUZZERS=FALSE \
  -DJPEGXL_ENABLE_DEVTOOLS=FALSE \
  -DJPEGXL_ENABLE_TOOLS=FALSE \
  -DJPEGXL_ENABLE_JPEGLI=FALSE \
  -DJPEGXL_ENABLE_JPEGLI_LIBJPEG=FALSE \
  -DJPEGXL_ENABLE_DOXYGEN=FALSE \
  -DJPEGXL_ENABLE_MANPAGES=FALSE \
  -DJPEGXL_ENABLE_BENCHMARK=FALSE \
  -DJPEGXL_ENABLE_EXAMPLES=FALSE \
  -DJPEGXL_BUNDLE_LIBPNG=FALSE \
  -DJPEGXL_ENABLE_JNI=FALSE \
  -DJPEGXL_ENABLE_SKCMS=FALSE \
  -DJPEGXL_ENABLE_SJPEG=FALSE \
  ..
ninja install/strip
add_sbom "libjxl" $LIBJXL_VERSION \
  "cpe:2.3:a:libjxl_project:libjxl:$LIBJXL_VERSION:*:*:*:*:*:*:*"

print_build_stage libpng $LIBPNG_VERSION
cd $DEPS_SRC/libpng
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)
add_sbom "libpng" $LIBPNG_VERSION \
  "cpe:2.3:a:libpng:libpng:$LIBPNG_VERSION:*:*:*:*:*:*:*"

print_build_stage libwebp $LIBWEBP_VERSION
cd $DEPS_SRC/libwebp
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --enable-libwebpmux \
  --enable-libwebpdemux
make install-strip -j$(nproc)
add_sbom "libwebp" $LIBWEBP_VERSION \
  "cpe:2.3:a:webmproject:libwebp:$LIBWEBP_VERSION:*:*:*:*:*:*:*"

print_build_stage libtiff $LIBTIFF_VERSION
cd $DEPS_SRC/libtiff
mkdir _build
cd _build
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DBUILD_SHARED_LIBS=TRUE \
  -Dtiff-tools=FALSE \
  -Dtiff-tests=FALSE \
  -Dtiff-contrib=FALSE \
  -Dtiff-docs=FALSE \
  -Dtiff-deprecated=FALSE \
  ..
ninja install/strip
add_sbom "libtiff" $LIBTIFF_VERSION \
  "cpe:2.3:a:libtiff:libtiff:$LIBTIFF_VERSION:*:*:*:*:*:*:*"

print_build_stage cgif $CGIF_VERSION
cd $DEPS_SRC/cgif
CFLAGS="${CFLAGS} -O3" \
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib
ninja -C _build
ninja -C _build install
add_sbom "cgif" $CGIF_VERSION \
  "cpe:2.3:a:dloebl:cgif:$CGIF_VERSION:*:*:*:*:*:*:*"

print_build_stage libde265 $LIBDE265_VERSION
cd $DEPS_SRC/libde265
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3 -pthread" CXXFLAGS="${CXXFLAGS} -O3 -pthread" \
LDFLAGS="${LDFLAGS} -pthread" \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  --preset=release \
  -DBUILD_SHARED_LIBS=1 \
  ..
ninja install/strip
add_sbom "libde265" $LIBDE265_VERSION \
  "cpe:2.3:a:struktur:libde265:$LIBDE265_VERSION:*:*:*:*:*:*:*"

print_build_stage kvazaar $KVAZAAR_VERSION
cd $DEPS_SRC/kvazaar
./autogen.sh
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static
make install-strip -j$(nproc)
add_sbom "kvazaar" $KVAZAAR_VERSION \
  "cpe:2.3:a:ultravideo:kvazaar:$KVAZAAR_VERSION:*:*:*:*:*:*:*"

print_build_stage dav1d $DAV1D_VERSION
cd $DEPS_SRC/dav1d
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib
ninja -C _build
ninja -C _build install
add_sbom "dav1d" $DAV1D_VERSION \
  "cpe:2.3:a:videolan:dav1d:$DAV1D_VERSION:*:*:*:*:*:*:*"

# print_build_stage rav1e $RAV1E_VERSION
# cd $DEPS_SRC/rav1e
# cargo cinstall \
#   --release \
#   --library-type=cdylib \
#   --prefix=$TARGET_PATH \
#   --libdir=$TARGET_PATH/lib
# add_sbom "rav1e" $RAV1E_VERSION \
#   "cpe:2.3:a:xiph:rav1e:$RAV1E_VERSION:*:*:*:*:*:*:*"

print_build_stage aom $AOM_VERSION
cd $DEPS_SRC/aom
mkdir _build
cd _build
AOM_AS_FLAGS=#{CFLAGS} \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DBUILD_SHARED_LIBS=1 \
  -DENABLE_DOCS=0 \
  -DENABLE_TESTS=0 \
  -DENABLE_TESTDATA=0 \
  -DENABLE_TOOLS=0 \
  -DENABLE_EXAMPLES=0 \
  -DCONFIG_WEBM_IO=0 \
  ..
ninja install/strip
add_sbom "aom" $AOM_VERSION \
  "cpe:2.3:a:aomedia:aomedia:$AOM_VERSION:*:*:*:*:*:*:*"

print_build_stage libheif $LIBHEIF_VERSION
cd $DEPS_SRC/libheif
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  --preset=release-noplugins \
  -DBUILD_SHARED_LIBS=1 \
  -DWITH_EXAMPLES=0 \
  -DWITH_KVAZAAR=1 \
  -DWITH_DAV1D=1 \
  -DWITH_DAV1D_PLUGIN=0 \
  -DWITH_AOM_DECODER=0 \
  ..
ninja install/strip
add_sbom "libheif" $LIBHEIF_VERSION \
  "cpe:2.3:a:struktur:libheif:$LIBHEIF_VERSION:*:*:*:*:*:*:*"

print_build_stage freetype $FREETYPE_VERSION
cd $DEPS_SRC/freetype
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dzlib=enabled \
  -Dpng=disabled \
  -Dharfbuzz=disabled \
  -Dbrotli=disabled \
  -Dbzip2=disabled
ninja -C _build
ninja -C _build install
add_sbom "freetype" $FREETYPE_VERSION \
  "cpe:2.3:a:freetype:freetype:$FREETYPE_VERSION:*:*:*:*:*:*:*"

print_build_stage fontconfig $FONTCONFIG_VERSION
cd $DEPS_SRC/fontconfig
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Ddoc=disabled \
  -Dnls=disabled \
  -Dtests=disabled \
  -Dtools=disabled \
  -Dcache-build=disabled
ninja -C _build
ninja -C _build install
add_sbom "fontconfig" $FONTCONFIG_VERSION \
  "cpe:2.3:a:fontconfig_project:fontconfig:$FONTCONFIG_VERSION:*:*:*:*:*:*:*"

print_build_stage harfbuzz $HARFBUZZ_VERSION
cd $DEPS_SRC/harfbuzz
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dgobject=disabled \
  -Dicu=disabled \
  -Dtests=disabled \
  -Dintrospection=disabled \
  -Ddocs=disabled \
  -Dbenchmark=disabled \
  -Dgpu=disabled \
  -Dgpu_demo=disabled
ninja -C _build
ninja -C _build install
rm $TARGET_PATH/lib/libharfbuzz-subset*
add_sbom "harfbuzz" $HARFBUZZ_VERSION \
  "cpe:2.3:a:harfbuzz_project:harfbuzz:$HARFBUZZ_VERSION:*:*:*:*:*:*:*"

print_build_stage pixman $PIXMAN_VERSION
cd $DEPS_SRC/pixman
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dlibpng=disabled \
  -Dgtk=disabled \
  -Dopenmp=disabled \
  -Ddemos=disabled \
  -Dtests=disabled
ninja -C _build
ninja -C _build install
add_sbom "pixman" $PIXMAN_VERSION \
  "cpe:2.3:a:pixman:pixman:$PIXMAN_VERSION:*:*:*:*:*:*:*"

print_build_stage cairo $CAIRO_VERSION
cd $DEPS_SRC/cairo
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dfontconfig=enabled \
  -Dquartz=disabled \
  -Dtee=disabled \
  -Dxcb=disabled \
  -Dxlib=disabled \
  -Dzlib=disabled \
  -Dtests=disabled \
  -Dspectre=disabled \
  -Dsymbol-lookup=disabled
ninja -C _build
ninja -C _build install
add_sbom "cairo" $CAIRO_VERSION \
  "cpe:2.3:a:cairographics:cairo:$CAIRO_VERSION:*:*:*:*:*:*:*"

print_build_stage fribidi $FRIBIDI_VERSION
cd $DEPS_SRC/fribidi
autoreconf -fiv
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)
add_sbom "fribidi" $FRIBIDI_VERSION \
  "cpe:2.3:a:gnu:fribidi:$FRIBIDI_VERSION:*:*:*:*:*:*:*"

print_build_stage pango $PANGO_VERSION
cd $DEPS_SRC/pango
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dgtk_doc=false \
  -Dintrospection=disabled \
  -Dfontconfig=enabled
ninja -C _build
ninja -C _build install
add_sbom "pango" $PANGO_VERSION \
  "cpe:2.3:a:gnome:pango:$PANGO_VERSION:*:*:*:*:*:*:*"

print_build_stage librsvg $LIBRSVG_VERSION
cd $DEPS_SRC/librsvg
# Remove pdf and ps support
sed -i'.bak' "/cairo-rs = /s/, \"pdf\", \"ps\"//" {librsvg-c,rsvg}/Cargo.toml
# Skip executables
sed -i'.bak' "/subdir('rsvg_convert')/d" meson.build
# For some reason, librsvg fails to build without -ldl
CFLAGS="${CFLAGS} -ldl" CXXFLAGS="${CXXFLAGS} -ldl" \
LDFLAGS="${LDFLAGS} -ldl" \
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dintrospection=disabled \
  -Dpixbuf{,-loader}=disabled \
  -Ddocs=disabled \
  -Dvala=disabled \
  -Dtests=false \
  -Davif=enabled
ninja -C _build
ninja -C _build install
add_sbom "librsvg" $LIBRSVG_VERSION \
  "cpe:2.3:a:gnome:librsvg:$LIBRSVG_VERSION:*:*:*:*:*:*:*"

print_build_stage vips $VIPS_VERSION
cd $DEPS_SRC/vips
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Ddocs=false \
  -Dintrospection=disabled \
  -Dmodules=disabled
ninja -C _build
ninja -C _build install
rm -rf $TARGET_PATH/lib/libvips-cpp.*
add_sbom "vips" $VIPS_VERSION \
  "cpe:2.3:a:libvips:libvips:$VIPS_VERSION:*:*:*:*:*:*:*"

rm -rf $TARGET_PATH/lib/*.a
rm -rf $TARGET_PATH/lib/*.la
