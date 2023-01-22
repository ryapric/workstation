#!/usr/bin/env bash
set -euo pipefail

init-virtualbox() {
  log-info 'Installing & configuring VirtualBox...'

  get-apt-key \
    'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
    'virtualbox.gpg'
  log-warn 'Using hardcoded "bullseye" as the Debian version for VirtualBox APT list'
  sudo sh -c 'printf "deb https://download.virtualbox.org/virtualbox/debian bullseye contrib\n" > /etc/apt/sources.list.d/virtualbox.list'

  log-info 'Auto-agreeing to VirtualBox extpack terms...'
  sudo sh -c 'echo "virtualbox-ext-pack virtualbox-ext-pack/license select true" | debconf-set-selections'

  sudo apt-get update
  sudo apt-get install -y \
    linux-headers-amd64 \
    virtualbox \
    virtualbox-dkms \
    virtualbox-ext-pack \
    virtualbox-guest-additions-iso \
    virtualbox-guest-utils \
    virtualbox-guest-x11 \
    virtualbox-qt \
  || log-warn 'VirtualBox installation might not have succeeded -- you will want to try again after a reboot (because maybe the kernel was updated)'
  # ^ the above log doesn't actually seem to emit, because I think the VBox
  # installation failure still returns 0. But, leaving it just in case

  log-info 'Allowing all IP address ranges for VirtualBox...'
  sudo mkdir -p /etc/vbox
  sudo sh -c 'printf "* 0.0.0.0/0 ::/0\n" > /etc/vbox/networks.conf'
}
