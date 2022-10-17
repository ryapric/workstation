#!/usr/bin/env bash
set -euo pipefail

init-vscode() {
  log-info 'Installing Visual Studio Code...'

  get-apt-key \
    'https://packages.microsoft.com/keys/microsoft.asc' \
    'microsoft.gpg'
  sudo sh -c 'printf "deb https://packages.microsoft.com/repos/code stable main\n" > /etc/apt/sources.list.d/vscode.list'

  sudo apt-get update
  sudo apt-get install -y code
}
