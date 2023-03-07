#!/usr/bin/env bash
set -euo pipefail

init-virtualization() {
  run init-libvirt
  # run init-virtualbox
}

init-libvirt() {
  log-info 'Installing & configuring libvirt & friends...'

  sudo apt-get install -y \
    bridge-utils \
    libvirt-daemon-system \
    qemu-system \
    virt-manager
  sudo usermod -aG libvirt "${USER}"

# TODO: WHY DOES THE FUNC CALL STOP BEFORE HERE. I can source & run the wrapper
# func manually, and it even *installs more packages*, wtf. Bridge setup breaks
# Vagrant network though, but that's a separate issue.

#   log-info 'Adding bridge network for libvirt...'

#   sudo brctl addbr br0 || true
#   iface="$(ip link show | grep -E '\seth[0-9]' | awk '{ gsub(":", "", $2) ; print $2 }')"
#   sudo brctl addif br0 "${iface}"
#   printf "# libvirt bridge setup
# iface br0 inet static
#   bridge_ports %s
#     address 10.0.1.1
#     netmask 255.255.255.0" "${iface}" \
#     | sudo tee /etc/network/interfaces.d/libvirt-bridge
#   sudo ifup br0
}

# init-virtualbox() {
#   log-info 'Installing & configuring VirtualBox...'

#   get-apt-key \
#     'https://www.virtualbox.org/download/oracle_vbox_2016.asc' \
#     'virtualbox.gpg'
#   log-warn 'Using hardcoded "bullseye" as the Debian version for VirtualBox APT list'
#   sudo sh -c 'printf "deb https://download.virtualbox.org/virtualbox/debian bullseye contrib\n" > /etc/apt/sources.list.d/virtualbox.list'

#   log-info 'Auto-agreeing to VirtualBox extpack terms...'
#   sudo sh -c 'echo "virtualbox-ext-pack virtualbox-ext-pack/license select true" | debconf-set-selections'

#   sudo apt-get update
#   sudo apt-get install -y \
#     linux-headers-amd64 \
#     virtualbox \
#     virtualbox-dkms \
#     virtualbox-ext-pack \
#     virtualbox-guest-additions-iso \
#     virtualbox-guest-utils \
#     virtualbox-guest-x11 \
#     virtualbox-qt \
#   || log-warn 'VirtualBox installation might not have succeeded -- you will want to try again after a reboot (because maybe the kernel was updated)'
#   # ^ the above log doesn't actually seem to emit, because I think the VBox
#   # installation failure still returns 0. But, leaving it just in case

#   log-info 'Allowing all IP address ranges for VirtualBox...'
#   sudo mkdir -p /etc/vbox
#   sudo sh -c 'printf "* 0.0.0.0/0 ::/0\n" > /etc/vbox/networks.conf'
# }
