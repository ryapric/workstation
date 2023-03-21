#!/usr/bin/env bash
set -euo pipefail

init-rust() {
  log-info 'Installing rust...'
  curl -fsSL -O https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init
  chmod +x ./rustup-init
  ./rustup-init -y
  rm ./rustup-init
}
