#!/usr/bin/env bash
set -euo pipefail

init-hashicorp() {
  log-info 'Installing HashiCorp tools...'

  get-apt-key \
    'https://apt.releases.hashicorp.com/gpg' \
    'hashicorp.gpg'
  log-warn 'Using hardcoded "bullseye" as Debian version for HashiCorp APT list'
  sudo sh -c 'printf "deb https://apt.releases.hashicorp.com bullseye main\n" > /etc/apt/sources.list.d/hashicorp.list'

  sudo apt-get update
  sudo apt-get install -y \
    packer \
    terraform \
    vagrant \
    vault
}
