#!/usr/bin/env bash
set -euo pipefail

init-R() {
  log-info 'Installing R...'
  sudo apt-get install -y \
    r-base \
    r-base-dev

  log-info 'Installing RStudio IDE...'
  if ! command -v rstudio > /dev/null ; then
    # shellcheck disable=SC2155
    local rstudio_dl_link="$(curl -fsSL 'https://www.rstudio.com/products/rstudio/download/' | grep -E -o '"https.*bionic.*amd64\.deb"' | sed 's/"//g')"
    curl -fsSL -o /tmp/rstudio.deb "${rstudio_dl_link}"
    sudo apt-get install -y /tmp/rstudio.deb
  fi
}
