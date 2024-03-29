#!/usr/bin/env bash
set -euo pipefail

init-dotfiles() {
  log-info 'Setting up dotfiles repo...'
  if [[ -d /tmp/dotfiles ]] ; then
    log-info 'Found Vagrant-provided repo, /tmp/dotfiles'
    mkdir -p "${HOME}"/repos/ryapric/workstation
    sudo cp -r /tmp/{system,dotfiles} "${HOME}"/repos/ryapric/workstation/
    sudo chown -R ryan:ryan "${HOME}"/repos/ryapric/workstation/
  else
    if [[ ! -d "${HOME}"/repos/ryapric/workstation ]] ; then
      git clone https://github.com/ryapric/workstation.git "${HOME}"/repos/ryapric/workstation
      log-info 'Fixing git remote for dotfiles repo...'
      git -C "${HOME}"/repos/ryapric/workstation remote set-url origin git@github.com:ryapric/workstation.git
    fi
  fi

  log-info 'Setting up dotfile symlinks...'
  make -C "${HOME}"/repos/ryapric/workstation dotfiles-link
}
