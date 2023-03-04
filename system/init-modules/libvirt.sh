#!/usr/bin/env bash
set -euo pipefail

init-libvirt() {
  log-info 'Installing & configuring libvirt...'

  sudo apt-get install -y \
    libvirt-daemon-system \
    vagrant-libvirt
  sudo usermod -aG libvirt "${USER}"
}
