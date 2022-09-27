#!/usr/bin/env bash
set -euo pipefail

init-sys() {
  log-info 'Installing system utilities...'
  sudo apt-get update
  sudo apt-get install -y \
    apt-transport-https \
    curl \
    gnupg2 \
    htop \
    jq \
    make \
    shellcheck \
  || log-error 'Failed to install some system packages!'
}
