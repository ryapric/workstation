#!/usr/bin/env bash
set -euo pipefail

init-core() {
  log-info 'Bumping OS to Debian Sid/Unstable...'
  # TODO: There's a lot of root calls here, so it's all a single string call.
  # There are myriad ways I could do this instead, but this works right now, so.
  sudo bash -c '
  export DEBIAN_FRONTEND=noninteractive
  export APT_LISTCHANGES_FRONTEND=none
  echo "libc6 libraries/restart-without-asking boolean true" | debconf-set-selections
  apt-get update
  apt-get install -y apt-transport-https
  rm /etc/apt/sources.list
  printf "deb https://deb.debian.org/debian unstable main contrib non-free\n" >> /etc/apt/sources.list
  printf "deb-src https://deb.debian.org/debian unstable main contrib non-free\n" >> /etc/apt/sources.list
  apt-get update
  # This dpkg option forces replacement of config files with the maintainer
  # versions; otherwise, a prompt appears
  apt-get -o Dpkg::Options::="--force-confnew" dist-upgrade -y
  '

  log-info 'Installing system utilities...'
  sudo apt-get update
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    blueman \
    bluez \
    curl \
    git \
    gnupg2 \
    htop \
    jq \
    lsb-release \
    make \
    net-tools \
    nmap \
    p7zip \
    ripgrep \
    rsync \
    shellcheck \
    software-properties-common \
    tmux \
    zsh \
  || log-error 'Failed to install some system packages!'

  log-info 'Adding directories that might need to be found later...'
  mkdir -p \
    "${HOME}/.local/bin"
}
