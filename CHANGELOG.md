# Changelog

## [3.8.0] - 2023-11-18
### Add
- Add highway.
- Add kvazaar.

### Change
- Update Go to 1.21.4.
- Update GLib to 2.78.1.
- Update libxml2 to 2.12.0.
- Update libheif to 1.17.3.
- Update harfbuzz to 8.3.0.
- Update pango to 1.51.1.
- Update vips to 8.15.0.
- Patch vips to use `vips_concurrency_get()` threads in `heifsave`.

## [3.7.5] - 2023-10-24
### Change
- Enable GIF gdkpixbuf loader.
- Patch vips to set default NCLX profile to HEIC/AVIF if no ICC profile is provided.

## [3.7.4] - 2023-10-21
### Change
- Update Go to 1.21.3.
- Update zlib to 2.1.4.
- Update libjpegturbo to 3.0.1.
- Update libheif to 1.17.1.
- Update harfbuzz to 8.2.2.
- Patch vips to correctly treat EXIF strings with invalid UTF8 characters.
- Patch vips to fix possible segfault in heifload.

## [3.7.3] - 2023-10-05
### Change
- Update Go to 1.21.1.
- Update GLib to 2.78.0.
- Update libwebp to 1.3.2.
- Update libtiff to 4.6.0.
- Update dav1d to 1.3.0.
- Update harfbuzz to 8.2.1.
- Update cairo to 1.18.0.
- Update pango to 1.51.1.
- Update librsvg to 2.57.0.
- Update vips to 8.14.5.
- Patch vips to fix invalid UTF-8 strings instead of ignoring them.
- Patch vips for 16-bit float TIFFs support.
- Patch vips for OJPEG TIFFs support.

## [3.7.2] - 2023-09-04
### Change
- Update GLib to 2.77.3.
- Update aom to 3.7.0.
- Update freetype to 2.13.2.
- Update librsvg to 2.56.93.
- Enable HDR support in aom.

## [3.7.1] - 2023-08-22
### Fix
- Fix building libheif with dav1d support.

## [3.7.0] - 2023-08-20
### Change
- Change base image to `debian:stable-slim`.
- Update Go to 1.21.0.
- Update GLib to 2.77.2.
- Update libxml2 to 2.11.5.
- Update harfbuzz to 8.1.1.
- Update pango to 1.51.0.
- Update librsvg to 2.56.92.
- Update vips to 8.14.4.
- Update vips patches.

## [3.6.1] - 2023-07-13
### Change
- Update Go to 1.20.6.
- Update zlib to 2.1.3.
- Update GLib to 2.77.0.
- Update libjpegturbo to 3.0.0.
- Update libwebp to 1.3.1.
- Update harfbuzz to 8.0.0.
- Update librsvg to 2.56.90.

### Fix
- Fix SIMD-optimized methods in vips.

## [3.6.0] - 2023-06-28
### Add
- Add libyuv.

### Change
- Update Go to 1.20.5.
- Update zlib to 2.1.2.
- Update GLib to 2.76.3.
- Update libxml2 to 2.11.4.
- Update libtiff to 4.5.1.
- Update cgif to 0.3.2.
- Update libde265 to 1.0.12.
- Update dav1d to 1.2.1.
- Update libheif to 1.16.2.
- Update freetype to 2.13.1.
- Update librsvg to 2.56.1.
- Add SIMD optimizations to vips.
- Patch libheif to support libyuv.

### Removed
- Removed orc.

## [3.5.1] - 2023-05-23
### Change
- Set optimization flags for some libraries.

## [3.5.0] - 2023-05-17
### Add
- Add zlib-ng 2.0.7.
- Add ffi 3.4.4.

### Changed
- Update fribidi to 1.0.13.

## [3.4.0] - 2023-05-16
### Add
- Add orc 0.4.33.

### Changed
- Update Go to 1.20.4.
- Update GLib to 2.76.2.
- Update libxml2 to 2.11.3.
- Update lcms2 to 2.15.
- Update libjpegturbo to 2.1.91.
- Update libspng to 0.7.4.
- Update cgif to 0.3.1.
- Update dav1d to 1.2.0.
- Update aom to 3.6.1.
- Update libheif to 1.16.1.
- Update freetype to 2.13.0.
- Update harfbuzz to 7.3.0.
- Update pango to 1.50.14.
- Update librsvg to 2.56.0.
- Update vips to 8.14.2.

### Removed
- Remove libcroco.

## [3.3.5] - 2023-02-06
### Changed
- Update Go to 1.20.
- Update GLib to 2.75.2.
- Update libjpegturbo to 2.1.90.
- Update libspng to 0.7.3.
- Update libwebp to 1.3.0.
- Update libtiff to 4.5.0.
- Update libde265 to 1.0.11.
- Update libheif to 1.14.2.
- Update fontconfig to 2.14.2.
- Update harfbuzz to 6.0.0.
- Update cairo to 1.17.8.
- Update pango to 1.50.12.
- Update librsvg to 2.55.90.
- Update vips to 8.14.1.

## [3.3.4] - 2022-11-17
### Changed
- Update Go to 1.19.3.
- Update GLib to 2.75.0.
- Update libexpat to 2.5.0.
- Update lcms2 to 2.14.
- Update libde265 to 1.0.9.
- Update libheif to 1.14.0.
- Update gdkpixbuf to 2.42.10.
- Update fontconfig to 2.14.1.
- Update harfbuzz to 5.3.1.
- Update pixman to 0.42.2.
- Update vips to 8.13.3.

## [3.3.3] - 2022-10-19
### Changed
- Update libxml2 to 2.10.3.
- Update harfbuzz to 5.3.0.
- Update pixman to 0.42.0.

### Fix
- Patch libvips to fix saving of paletted PNGs with low bit-depth.

## [3.3.2] - 2022-10-06
### Changed
- Update Go to 1.19.2.
- Update GLib to 2.74.0.
- Update libexpat to 2.4.9.
- Update libxml2 to 2.10.2.
- Update aom to 3.5.0.
- Update libheif to 1.13.0.
- Update harfbuzz to 5.2.0.
- Update pango to 1.50.11.
- Update librsvg to 2.55.1.
- Update vips to 8.13.2.

## [3.3.1] - 2022-08-19
### Changed
- Update Go to 1.19.
- Update GLib to 2.73.3.
- Update Quantizr to 1.4.1.
- Update libxml2 to 2.10.0.
- Update libjpegturbo to 2.1.4.
- Update libwebp to 1.2.4.
- Update gdkpixbuf to 2.42.9.
- Update harfbuzz to 5.1.0.
- Update pango to 1.50.9.
- Update librsvg to 2.55.0.
- Patch libvips to speed up GIF loading.

## [3.3.0] - 2022-07-25
### Add
- Add libspng 0.7.2.

### Changed
- Update Go to 1.18.4.
- Update GLib to 2.73.2.
- Update Quantizr to 1.3.0.
- Update libwebp to 1.2.3.
- Update libtiff to 4.4.0.
- Update aom to 3.4.0.
- Update harfbuzz to 4.4.1.
- Update pango to 1.50.8.
- Update librsvg to 2.54.4.
- Update vips to 8.13.0.
- Patch libheif.

## [3.2.4] - 2022-05-20
### Fix
- Fix dav1d plugin of libheif.

## [3.2.3] - 2022-05-15
### Changed
- Update Go to 1.18.2.
- Update GLib to 2.72.1.
- Update libxml2 to 2.9.14.
- Update cgif to 0.3.0.
- Update freetype to 2.12.1.
- Update harfbuzz to 4.2.1.
- Update fribidi to 1.0.12.
- Update pango to 1.50.7.
- Update librsvg to 2.54.3.

### Fix
- Patch libvips to not fail on PNGs with to many text chunks.

## [3.2.2] - 2022-04-13
### Changed
- Update Go to 1.18.
- Update GLib to 2.72.0.
- Update Quantizr to 1.2.0.
- Update libexpat to 2.4.8.
- Update libxml2 to 2.9.13.
- Update libjpegturbo to 2.1.3.
- Update cgif to 0.2.1.
- Update dav1d to 1.0.0.
- Update aom to 3.3.0.
- Update gdkpixbuf to 2.42.8.
- Update freetype to 2.12.0.
- Update fontconfig to 2.14.0.
- Update harfbuzz to 4.2.0.
- Update cairo to 1.17.6.
- Update pango to 1.50.6.
- Update librsvg to 2.54.0.

### Fix
- Patch nsgif in vips code to recover from LZW_EOI_CODE.

## [3.2.1] - 2022-02-11
### Fix
- Fix `CFLAGS` for amd64 build.

## [3.2.0] - 2022-02-07
### Added
- Add libaom 3.2.0.

### Changed
- Update lcms2 to 2.13.1.
- Update fontconfig to 2.13.96.
- Update harfbuzz to 3.3.2.

### Removed
- Remove rav1e.

## [3.1.0] - 2022-01-31
### Added
- Multiarch build.

### Changed
- Update Go to 1.17.6.
- Update GLib to 2.71.1.
- Update libexpat to 2.4.4.
- Update libexif to 0.6.24.
- Update lcms2 to 2.13.
- Update Quantizr to 1.1.0.
- Update libwebp to 1.2.2.
- Update rav1e to 0.5.1.
- Update freetype to 2.11.1.
- Update harfbuzz to 3.2.0.
- Update pango to 1.50.3.
- Update vips to 8.12.2.

## [3.0.1] - 2021-11-22
### Added
- Add cgif 0.0.2.

### Changed
- Update Go to 1.17.3.
- Update GLib to 2.70.1.
- Update libjpegturbo to 2.1.2.
- Update libpng to 1.6.37.
- Update Quantizr to 1.0.1.
- Update rav1e to 0.5.0.
- Update freetype to 2.11.0.
- Update harfbuzz to 3.1.1.
- Update pango to 1.49.3.
- Update vips to 8.12.0.

### Removed
- Remove ImageMagick.

## [3.0.0] - 2021-09-29
### Changed
- Update Go to 1.17.1.
- Update GLib to 2.70.0.
- Update libexif to 0.6.23.
- Update libjpegturbo to 2.1.1.
- Update libwebp to 1.2.1.
- Update dav1d to 0.9.2.
- Update fontconfig to 2.13.94.
- Update harfbuzz to 3.0.0.
- Update fribidi to 1.0.11.
- Update pango to 1.49.1.
- Update ImageMagick to 7.1.0-8.
- Update vips to 8.11.4.

## [1.4.0] - 2021-06-10
### Changed
- Use Debian Bullseye as a base.
- Reduce final image size by using multistage build.
- Update GLib to 2.68.2.
- Update libexpat to 2.4.1.
- Update libxml2 to 2.9.12.
- Update libjpegturbo to 2.1.0.
- Update libtiff to 4.3.0.
- Update dav1d to 0.9.0.
- Update rav1e to 0.4.1.
- Update libheif to 1.12.0.
- Update gdkpixbuf to 2.42.6.
- Update harfbuzz to 2.8.1.
- Update pango to 1.48.5.
- Update librsvg to 2.50.7.
- Update ImageMagick to 7.0.11-14.
- Update vips to 8.11.0.

### Fix
- Fix librsvg panics when processing some SVGs.

### Removed
- Remove giflib (libvips has builtin libnsgif now).

## [1.3.2] - 2021-03-04
### Changed
- Update GLib to 2.67.5.
- Update lcms2 to 2.12.
- Update libwebp to 1.2.0.
- Update libtiff to 4.2.0.
- Update dav1d to 0.8.2.
- Update rav1e to 0.4.0.
- Update libheif to 1.11.0.
- Update harfbuzz to 2.7.4.
- Update pango to 1.48.2.
- Update librsvg to 2.50.3.
- Update ImageMagick to 7.0.11-2.
- Update vips to 8.10.5.

## [1.3.1] - 2020-12-15
### Changed
- Update GLib to 2.67.0.
- Update libexpat to 2.2.10.
- Update libjpegturbo to 2.0.90.
- Update libde265 to 1.0.8.
- Update dav1d to 0.8.0.
- Update gdkpixbuf to 2.42.2.
- Update freetype to 2.10.4.
- Update fontconfig to 2.13.93.
- Update pango to 1.48.0.
- Update librsvg to 2.50.2.
- Update ImageMagick to 7.0.10-48.
- Update libvips to 8.10.4.

## [1.3.0] - 2020-09-15
### Added
- Add rav1e 0.3.4.
- Add dav1d 0.7.1.

# Removed
- Remove libaom.

## [1.2.0] - 2020-09-15
### Added
- Add libaom 2.0.0.

### Changed
- Update GLib to 2.66.0.
- Update harfbuzz to 2.7.2.
- Update librsvg to 2.50.0.
- Update ImageMagick to 7.0.10-29.
- Update libvips to 8.10.1.

## [1.0.4] - 2020-08-27
### Changed
- Update GLib to 2.65.2.
- Update libde265 to 1.0.6.
- Update libheif to 1.8.0.
- Update harfbuzz to 2.7.1.
- Update pango to 1.46.1.
- Update librsvg to 2.49.4.
- Update ImageMagick to 7.0.10-28.

## [1.0.3] - 2020-08-11
### Changed
- Update GLib version to 2.65.1.
- Update libjpegturbo version to 2.0.5.
- Update harfbuzz version to 2.7.0.
- Update fribidi version to 1.0.10.
- Update pango version to 1.46.0.
- Update librsvg version to 2.49.3.
- Update ImageMagick version to 7.0.10-26.
- Update libvips version to 8.10.0.

## [1.0.2] - 2020-07-09
### Fix
- Fix libde265 build

## [1.0.1] - 2020-06-22
### Changed
- Update GLib version to 2.65.0.
- Update lcms2 version to 2.11.
- Update ImageMagick version to 7.0.10-20.

## [1.0.0] - 2020-06-16
### Added
- First release.
