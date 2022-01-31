ARG TARGET_ARCH=amd64

FROM debian:bullseye-slim AS base

ARG TARGET_ARCH

RUN dpkg --add-architecture ${TARGET_ARCH} \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    ca-certificates \
    crossbuild-essential-${TARGET_ARCH} \
    pkg-config \
    libssl-dev \
    libstdc++6:${TARGET_ARCH} \
    libffi-dev:${TARGET_ARCH} \
    zlib1g-dev:${TARGET_ARCH} \
    liblzma-dev:${TARGET_ARCH} \
    libzstd-dev:${TARGET_ARCH} \
    libpcre3-dev:${TARGET_ARCH}

WORKDIR /root

# ==============================================================================

FROM base AS deps-src

COPY versions.sh download-deps.sh ./
RUN ./download-deps.sh

# ==============================================================================

FROM base AS deps

ARG TARGET_ARCH

COPY install-rust.sh ./

RUN apt-get install -y --no-install-recommends \
    autoconf \
    autopoint \
    automake \
    cmake \
    nasm \
    yasm \
    libtool \
    ninja-build \
    python3-pip \
    python-is-python3 \
    gettext \
    gperf \
  && ./install-rust.sh \
  && pip3 install meson setuptools

COPY versions.sh build-deps.sh build-bash-profile.sh *.patch meson_${TARGET_ARCH}.ini ./
COPY --from=deps-src /root/deps /root/deps

# We need environment variables that based on the TARGET_ARCH,
# so we have to use a Bash profile instead of ENV
RUN ./build-bash-profile.sh > /root/.bashrc
ENV BASH_ENV=/root/.bashrc

RUN ./build-deps.sh

# ==============================================================================

FROM --platform=${TARGET_ARCH} debian:bullseye-slim AS final
LABEL maintainer="Sergey Alexandrovich <darthsim@gmail.com>"

ARG TARGET_ARCH

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    ca-certificates \
    build-essential \
    pkg-config \
    libssl-dev \
    libstdc++6 \
    libffi-dev \
    zlib1g-dev \
    liblzma-dev \
    libzstd-dev \
    libpcre3-dev

WORKDIR /root

# install Go
COPY versions.sh install-go.sh ./
RUN ./install-go.sh
ENV PATH $PATH:/usr/local/go/bin

COPY --from=deps /usr/local/lib /usr/local/lib
COPY --from=deps /usr/local/include /usr/local/include

COPY --from=deps /root/.bashrc /root/.bashrc
ENV BASH_ENV=/root/.bashrc

WORKDIR /app
CMD bash
