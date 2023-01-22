#!/usr/bin/env bash
set -euo pipefail

init-xfce4() {
  log-info 'Installing XFCE4 desktop environment...'

  sudo apt-get install -y \
    xfce4 \
    xfce4-goodies
}
