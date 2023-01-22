#!/usr/bin/env bash
set -euo pipefail

init-game-emulators() {
  log-info 'Installing game emulators...'

  mkdir -p "${HOME}"/GameROMs

  # mupen64plus is plugin-based, so the glob will get any available
  sudo apt-get install -y \
    'mupen64plus-*'
    # TODO: broken in Sid until Qt req is bumped
    # dolphin-emu \
    # dolphin-emu-data \
}
