#!/usr/bin/env bash
set -euo pipefail

init-docker() {
  log-info 'Installing Docker...'

  get-apt-key \
    'https://download.docker.com/linux/debian/gpg' \
    'docker.gpg'
  log-warn 'Using hardcoded "bullseye" as the Debian version for Docker APT list'
  sudo sh -c 'printf "deb https://download.docker.com/linux/debian bullseye stable\n" > /etc/apt/sources.list.d/docker.list'

  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  sudo usermod -aG docker ryan
}
