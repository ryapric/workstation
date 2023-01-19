#!/usr/bin/env bash
set -euo pipefail

init-go() {
  log-info 'Installing Go...'
  sudo apt-get install -y golang

  log-info 'Installing Go tooling...'
  pkgs=(
    golang.org/x/pkgsite/cmd/pkgsite@latest
  )

  for pkg in "${pkgs[@]}" ; do go install "${pkg}" ; done
}
