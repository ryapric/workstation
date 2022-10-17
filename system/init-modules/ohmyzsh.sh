#!/usr/bin/env bash
set -euo pipefail

init-ohmyzsh() {
  log-info 'Setting up Oh My Zsh...'

  # shellcheck disable=SC2155
  local zsh_path="$(command -v zsh)"
  [[ "${SHELL}" == "${zsh_path}" ]] || sudo chsh -s "${zsh_path}" ryan
  [[ -d /tmp/oh-my-zsh ]] || git -C /tmp clone https://github.com/ohmyzsh/ohmyzsh.git oh-my-zsh
  [[ -d "${HOME}"/.oh-my-zsh ]] || bash /tmp/oh-my-zsh/tools/install.sh --unattended
}
