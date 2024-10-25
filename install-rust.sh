#!/bin/bash
set -e

PATH="/root/.cargo/bin:$PATH"

curl https://sh.rustup.rs -sSf | sh -s -- -y
cargo install cargo-c
