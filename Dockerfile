FROM --platform=${BUILDPLATFORM} debian:stable-slim AS base

ARG TARGETARCH

RUN dpkg --add-architecture ${TARGETARCH} \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    ca-certificates \
    crossbuild-essential-${TARGETARCH} \
    pkg-config \
    libssl-dev \
    libstdc++6:${TARGETARCH} \
    liblzma-dev:${TARGETARCH} \
    libzstd-dev:${TARGETARCH}

WORKDIR /root

# ==============================================================================

FROM --platform=${BUILDPLATFORM} base AS deps-src

COPY versions.sh download-deps.sh ./
RUN ./download-deps.sh

# ==============================================================================

FROM --platform=${BUILDPLATFORM} base AS deps

ARG TARGETARCH

COPY install-rust.sh ./

RUN apt-get install -y --no-install-recommends \
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
  && /root/.python/bin/pip install meson ninja

COPY versions.sh build-deps.sh build-bash-profile.sh *.patch meson_${TARGETARCH}.ini ./
COPY --from=deps-src /root/deps /root/deps

# We need environment variables that based on the TARGETARCH,
# so we have to use a Bash profile instead of ENV
RUN ./build-bash-profile.sh > /root/.bashrc
ENV BASH_ENV=/root/.bashrc

RUN ./build-deps.sh

# ==============================================================================

FROM --platform=${TARGETPLATFORM} debian:stable-slim AS final
LABEL maintainer="Sergey Alexandrovich <darthsim@gmail.com>"

ARG TARGETARCH

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
    liblzma-dev \
    libzstd-dev

WORKDIR /root

# install Go
COPY versions.sh install-go.sh ./
RUN ./install-go.sh
ENV PATH $PATH:/usr/local/go/bin

COPY --from=deps /usr/local/lib /usr/local/lib
COPY --from=deps /usr/local/include /usr/local/include
COPY --from=deps /usr/local/bin /usr/local/bin

COPY --from=deps /root/.bashrc /root/.bashrc
ENV BASH_ENV=/root/.bashrc

WORKDIR /app
CMD bash
