#!/usr/bin/env bash
set -euo pipefail

init-dotfiles() {
  log-info 'Setting up dotfiles repo...'
  [[ -d "${HOME}"/repos/ryapric/workstation ]] || git clone https://github.com/ryapric/workstation "${HOME}"/repos/ryapric/workstation

  log-info 'Fixing git remote for dotfiles repo...'
  git -C "${HOME}"/repos/ryapric/workstation remote set-url origin git@github.com:ryapric/workstation.git

  log-info 'Setting up dotfile symlinks...'
  make -C "${HOME}"/repos/ryapric/workstation dotfiles-link
}
