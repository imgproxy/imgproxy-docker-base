# Base image for building imgproxy and its dependencies.
ARG BASE_IMAGE=public.ecr.aws/ubuntu/ubuntu:22.04

# Use ubuntu 22.04 as a base image to link against glibc 2.35.
FROM ${BASE_IMAGE} AS base

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    curl \
    git \
    ca-certificates \
    build-essential \
    pkg-config \
    libssl-dev \
    libcurl4-openssl-dev \
    libstdc++-10-dev

WORKDIR /root

# ==============================================================================

FROM base AS deps-src

COPY versions.sh download-deps.sh ./
RUN ./download-deps.sh

# ==============================================================================

FROM base AS deps

COPY install-rust.sh ./

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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

COPY versions.sh build-deps.sh build-bash-profile.sh *.patch ./
COPY --from=deps-src /root/deps /root/deps

# We need environment variables that are based on the uname -m output,
# so we have to use a Bash profile instead of ENV
RUN ./build-bash-profile.sh > /root/.bashrc
ENV BASH_ENV=/root/.bashrc

RUN ./build-deps.sh

# ==============================================================================

FROM base AS golang

COPY versions.sh install-go.sh ./
RUN ./install-go.sh

# ==============================================================================

FROM ${BASE_IMAGE} AS final
LABEL maintainer="Sergey Alexandrovich <darthsim@gmail.com>"

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash \
    curl \
    ca-certificates \
    build-essential \
    pkg-config \
    libssl-dev \
    libstdc++-10-dev \
    software-properties-common \
    gpg-agent \
  && apt-get clean \
  && truncate -s 0 /var/log/*log \
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install LLVM 20 (for clang-format) and latest git (custom, newer versions)
RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-20 main" > /etc/apt/sources.list.d/llvm20.list \
  && curl -sSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt-add-repository ppa:git-core/ppa

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  git \
  clang-format \
  && apt-get clean \
  && truncate -s 0 /var/log/*log \
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root

COPY --from=golang /usr/local/go /usr/local/go
ENV PATH=$PATH:/usr/local/go/bin:/root/go/bin

RUN go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.5.0 \
  && go install github.com/evilmartians/lefthook@latest \
  && go install gotest.tools/gotestsum@latest \
  && go install github.com/air-verse/air@latest \
  && go clean -cache -modcache

COPY --from=deps /root/deps/lychee/lychee /usr/local/bin/lychee

COPY --from=deps /opt/imgproxy/lib /opt/imgproxy/lib
COPY --from=deps /opt/imgproxy/include /opt/imgproxy/include
COPY --from=deps /opt/imgproxy/bin /opt/imgproxy/bin

COPY --from=deps /root/.bashrc /root/.bashrc
ENV BASH_ENV=/root/.bashrc

ENV IMGPROXY_IN_BASE_CONTAINER=true

WORKDIR /app
CMD ["bash"]
