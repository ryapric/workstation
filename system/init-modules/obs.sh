#!/usr/bin/env bash
set -euo pipefail

init-obs-studio() {
  log-info 'Setting up OBS Studio...'

  sudo apt-get install -y obs-studio
}
