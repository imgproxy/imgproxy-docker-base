FROM golang:1-buster
LABEL maintainer="Sergey Alexandrovich <darthsim@gmail.com>"

ENV PATH="/root/.cargo/bin:$PATH"
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH /usr/local/lib
ENV CPATH /usr/local/include
ENV CGO_LDFLAGS_ALLOW "-s|-w"

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  bash \
  curl \
  git \
  ca-certificates \
  build-essential \
  autoconf \
  autopoint \
  automake \
  cmake \
  nasm \
  libtool \
  ninja-build \
  python3-pip \
  gettext \
  gperf \
  libffi-dev \
  zlib1g-dev \
  liblzma-dev \
  libzstd-dev \
  && curl https://sh.rustup.rs -sSf | sh -s -- -y \
  && pip3 install meson setuptools

WORKDIR /root
COPY . .
RUN ./build-deps.sh

WORKDIR /app
