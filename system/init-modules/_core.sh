#!/usr/bin/env bash
set -euo pipefail

init-core() {
  bump-to-debian-unstable

  log-info 'Installing system utilities...'
  sudo apt-get update
  # Install zstd first so apt warnings about it not being there go away
  sudo apt-get install -y zstd
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    bats \
    blueman \
    bluez \
    build-essential \
    cloc \
    curl \
    git \
    gnupg2 \
    htop \
    jq \
    lintian \
    lsb-release \
    make \
    neofetch \
    net-tools \
    nmap \
    parallel \
    postgresql-client \
    p7zip \
    ripgrep \
    rlwrap \
    rsync \
    shellcheck \
    socat \
    software-properties-common \
    tmux \
    tree \
    zsh \
  || log-error 'Failed to install some system packages!'

  sudo apt-get autoclean
  sudo apt-get autoremove -y

  log-info 'Adding directories that might need to be found later...'
  mkdir -p \
    "${HOME}/.local/bin" \
    "${HOME}"/repos
}

bump-to-debian-unstable() {
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
  printf "deb https://deb.debian.org/debian unstable main contrib non-free non-free-firmware\n" >> /etc/apt/sources.list
  printf "deb-src https://deb.debian.org/debian unstable main contrib non-free non-free-firmware\n" >> /etc/apt/sources.list
  apt-get update
  # This dpkg option forces replacement of config files with the maintainer
  # versions; otherwise, a prompt appears
  apt-get -o Dpkg::Options::="--force-confnew" dist-upgrade -y
  ' \
  || log-error 'Failed to bump OS version to Debian Sid/Unstable!'
}
