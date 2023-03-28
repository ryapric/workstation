#!/usr/bin/env bash
set -euo pipefail

init-rust() {
  log-info 'Installing rust...'
  curl -fsSL -o /tmp/rustup-init https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init
  chmod +x /tmp/rustup-init
  /tmp/rustup-init -y
  rm /tmp/rustup-init
}
