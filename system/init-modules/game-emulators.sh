#!/usr/bin/env bash
set -euo pipefail

init-game-emulators() {
  log-info 'Installing game emulators...'

  mkdir -p "${HOME}"/GameROMs

  # mupen64plus is plugin-based, so the glob will get any available
  sudo apt-get install -y \
    dolphin-emu \
    dolphin-emu-data \
    'mupen64plus-*'
}
