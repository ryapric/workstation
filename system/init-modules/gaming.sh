#!/usr/bin/env bash
set -euo pipefail

init-gaming() {
  log-info 'Installing Steam...'
  sudo dpkg --add-architecture i386
  sudo apt-get update
  sudo apt-get install -y steam

  log-info 'Installing game emulators...'
  mkdir -p "${HOME}"/GameROMs
  # mupen64plus is plugin-based, so the glob will get any available
  sudo apt-get install -y \
    'mupen64plus-*' \
    dolphin-emu \
    dolphin-emu-data
}
