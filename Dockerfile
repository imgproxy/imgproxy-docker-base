FROM debian:bullseye-slim AS base
LABEL maintainer="Sergey Alexandrovich <darthsim@gmail.com>"

ENV PATH="/root/.cargo/bin:$PATH"
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH /usr/local/lib
ENV CPATH /usr/local/include
ENV CGO_LDFLAGS_ALLOW "-s|-w"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    ca-certificates \
    build-essential \
    pkg-config \
    libssl-dev \
    libffi-dev \
    zlib1g-dev \
    liblzma-dev \
    libzstd-dev \
    libpcre3-dev

FROM base AS deps-src

WORKDIR /root
COPY versions.sh download-deps.sh ./
RUN ./download-deps.sh

FROM base AS deps

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    autoconf \
    autopoint \
    automake \
    cmake \
    nasm \
    yasm \
    libtool \
    ninja-build \
    python3-pip \
    gettext \
    gperf \
  && curl https://sh.rustup.rs -sSf | sh -s -- -y \
  && cargo install cargo-c \
  && pip3 install meson setuptools

WORKDIR /root
COPY versions.sh build-deps.sh *.patch ./
COPY --from=deps-src /root/deps /root/deps
RUN ./build-deps.sh

FROM base AS final

# install Go
COPY versions.sh install-go.sh ./
RUN ./install-go.sh
ENV PATH $PATH:/usr/local/go/bin

COPY --from=deps /usr/local/lib /usr/local/lib
COPY --from=deps /usr/local/include /usr/local/include

WORKDIR /app
