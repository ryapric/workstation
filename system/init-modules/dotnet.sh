#!/usr/bin/env bash
set -euo pipefail

init-dotnet() {
  log-info 'Installing .NET SDK...'

  # By following directions here:
  # https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian#debian-12
  #
  # TODO: note the hard-coded Debian version here
  curl -fsSL -o /tmp/msft.deb 'https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb'
  sudo dpkg -i /tmp/msft.deb
  rm -f /tmp/msft.deb

  dotnet_version="$(
    apt-cache search dotnet-sdk \
    | grep -E '^dotnet-sdk' \
    | sort \
    | tail -n1 \
    | awk '{ print $1 }'
  )"
  sudo apt-get update && sudo apt-get install -y "${dotnet_version}"
}
