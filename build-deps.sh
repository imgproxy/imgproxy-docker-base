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

print_build_stage glib $GLIB_VERSION
cd $DEPS_SRC/glib
# Build GLib without gregex
curl -Ls https://gist.githubusercontent.com/kleisauke/284d685efa00908da99ea6afbaaf39ae/raw/36e32c79e7962c5ea96cbb3f9c629e9145253e30/glib-without-gregex.patch | patch -p1
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

print_build_stage quantizr $QUANTIZR_VERSION
cd $DEPS_SRC/quantizr
cargo cinstall \
  --release \
  --library-type=cdylib \
  --prefix=$TARGET_PATH \
  --libdir=$TARGET_PATH/lib

print_build_stage expat $LIBEXPAT_VERSION
cd $DEPS_SRC/expat
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking \
  --without-xmlwf
make install -j$(nproc)

print_build_stage libxml2 $LIBXML2_VERSION
cd $DEPS_SRC/libxml2
./configure \
  --prefix=$TARGET_PATH \
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
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)

print_build_stage lcms2 $LCMS2_VERSION
cd $DEPS_SRC/lcms2
CFLAGS="${CFLAGS} -O3" \
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)

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

print_build_stage libpng $LIBPNG_VERSION
cd $DEPS_SRC/libpng
./configure \
  --prefix=$TARGET_PATH \
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
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib
ninja -C _build
ninja -C _build install

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

print_build_stage libde265 $LIBDE265_VERSION
cd $DEPS_SRC/libde265
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static
make install-strip -j$(nproc)

print_build_stage kvazaar $KVAZAAR_VERSION
cd $DEPS_SRC/kvazaar
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static
make install-strip -j$(nproc)

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

# print_build_stage rav1e $RAV1E_VERSION
# cd $DEPS_SRC/rav1e
# cargo cinstall \
#   --release \
#   --library-type=cdylib \
#   --prefix=$TARGET_PATH \
#   --libdir=$TARGET_PATH/lib

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

print_build_stage libyuv $LIBYUV_SHA
cd $DEPS_SRC/libyuv
mkdir _build
cd _build
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
cmake \
  -G"Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$TARGET_PATH \
  -DBUILD_SHARED_LIBS=1 \
  ..
ninja install/strip

print_build_stage libheif $LIBHEIF_VERSION
cd $DEPS_SRC/libheif
# libyuv support
curl -Ls https://github.com/DarthSim/libheif/commit/668ef49faa25d62faf02a5ee1c2fd0da426acd23.patch | git apply
# Ignore alpha in Op_RGB_HDR_to_RRGGBBaa_BE if aplpha has different BPP
curl -Ls https://github.com/DarthSim/libheif/commit/b3e71a5bd320b5d70b9f48f0aa02efc907c9bd36.patch | git apply
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
  -DWITH_AOM_DECODER=0 \
  ..
ninja install/strip

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

print_build_stage fontconfig $FONTCONFIG_VERSION
cd $DEPS_SRC/fontconfig
./configure \
  --prefix=$TARGET_PATH \
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
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dgobject=disabled \
  -Dicu=disabled \
  -Dtests=disabled \
  -Dintrospection=disabled \
  -Ddocs=disabled \
  -Dbenchmark=disabled
ninja -C _build
ninja -C _build install
rm $TARGET_PATH/lib/libharfbuzz-subset*

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

print_build_stage fribidi $FRIBIDI_VERSION
cd $DEPS_SRC/fribidi
autoreconf -fiv
./configure \
  --prefix=$TARGET_PATH \
  --enable-shared \
  --disable-static \
  --disable-dependency-tracking
make install-strip -j$(nproc)

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

print_build_stage vips $VIPS_VERSION
cd $DEPS_SRC/vips
CFLAGS="${CFLAGS} -O3" CXXFLAGS="${CXXFLAGS} -O3" \
meson setup _build \
  --buildtype=release \
  --strip \
  --wrap-mode=nofallback \
  --prefix=$TARGET_PATH \
  --libdir=lib \
  -Dgtk_doc=false \
  -Dintrospection=disabled \
  -Dmodules=disabled
ninja -C _build
ninja -C _build install
rm -rf $TARGET_PATH/lib/libvips-cpp.*

rm -rf $TARGET_PATH/lib/*.a
rm -rf $TARGET_PATH/lib/*.la
