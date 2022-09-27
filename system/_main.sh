#!/usr/bin/env bash
set -euo pipefail

################################################################################
# This script serves as the root caller of the functions defined in the various
# other scripts contained in this subdirectory
################################################################################

here=$(dirname "$(realpath "${0}")")

scripts=$(find "${here}" -not -path "${here}/_main.sh" -name '*.sh')
for script in ${scripts}; do
  #shellcheck disable=SC1090
  source "${script}"
done

if [[ $(id -u) -eq 0 ]]; then
  log-error 'You must run this script as your own user, not as root!'
fi

main() {
  # Core system utilities
  init-sys

  # Editor(s)
  # init-vscode
  # init-nanorc
  # init-ohmyzsh

  # Languages
  # init-go
  init-python
  # init-R

  # init-docker

  # init-hashicorp

  # init-protobuf
}

if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]];  then
  main
fi
