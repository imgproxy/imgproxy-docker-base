# Use Debian Bullseye as a base image to link against glibc 2.31
FROM --platform=${BUILDPLATFORM} debian:bullseye-slim AS base

ARG TARGETARCH

RUN dpkg --add-architecture ${TARGETARCH} \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    ca-certificates \
    crossbuild-essential-${TARGETARCH} \
    pkg-config \
    libssl-dev \
    libstdc++-10-dev:${TARGETARCH}

WORKDIR /root

# ==============================================================================

FROM --platform=${BUILDPLATFORM} base AS deps-src

COPY versions.sh download-deps.sh ./
RUN ./download-deps.sh

# ==============================================================================

FROM --platform=${BUILDPLATFORM} base AS deps

ARG TARGETARCH

COPY install-rust.sh ./

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    autoconf \
    autopoint \
    automake \
    cmake \
    nasm \
    libtool \
    python3-pip \
    python3-venv \
    gettext \
    gperf \
  && ./install-rust.sh \
  && python3 -m venv /root/.python \
  && /root/.python/bin/pip install meson ninja packaging

COPY versions.sh build-deps.sh build-bash-profile.sh *.patch cmake_${TARGETARCH}.cmake meson_${TARGETARCH}.ini ./
COPY --from=deps-src /root/deps /root/deps

# We need environment variables that based on the TARGETARCH,
# so we have to use a Bash profile instead of ENV
RUN ./build-bash-profile.sh > /root/.bashrc
ENV BASH_ENV=/root/.bashrc

RUN ./build-deps.sh

# ==============================================================================

FROM --platform=${BUILDPLATFORM} base as golang

COPY versions.sh install-go.sh ./
RUN ./install-go.sh

# ==============================================================================

FROM --platform=${TARGETPLATFORM} debian:bullseye-slim AS final
LABEL maintainer="Sergey Alexandrovich <darthsim@gmail.com>"

ARG TARGETARCH
ARG BUILDARCH

RUN dpkg --add-architecture ${BUILDARCH} \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    ca-certificates \
    build-essential \
    pkg-config \
    libssl-dev \
    libstdc++-10-dev

WORKDIR /root

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH $PATH:/usr/local/go/bin

COPY --from=deps /opt/imgproxy/lib /opt/imgproxy/lib
COPY --from=deps /opt/imgproxy/include /opt/imgproxy/include
COPY --from=deps /opt/imgproxy/bin /opt/imgproxy/bin

COPY --from=deps /root/.bashrc /root/.bashrc
ENV BASH_ENV=/root/.bashrc

WORKDIR /app
CMD bash
