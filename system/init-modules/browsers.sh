#!/usr/bin/env bash
set -euo pipefail

init-browsers() {
  log-info 'Installing browsers...'

  sudo apt-get install -y \
    firefox \
    torbrowser-launcher
}
