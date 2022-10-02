#!/usr/bin/env bash
set -euo pipefail

################################################################################
# This script serves as the root caller of the functions defined in the various
# other scripts contained in this subdirectory
################################################################################

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

here=$(dirname "$(realpath "${0}")")

scripts=$(find "${here}" -not -path "${here}/main.sh" -name '*.sh')
for script in ${scripts}; do
  #shellcheck disable=SC1090
  source "${script}"
done

if [[ $(id -u) -eq 0 ]]; then
  log-error 'You must run this script as your own user, not as root!'
  check-errors
fi

if ! command -v sudo > /dev/null ; then
  log-error 'sudo is not installed'
  check-errors
fi
if ! groups | grep -q 'sudo' ; then
  log-error 'Your user is not in the sudo user group'
  check-errors
fi

main() {
  # Core system utilities
  run init-sys

  # Editor(s)
  # run init-vscode
  # run init-nanorc

  # Shell
  # run init-ohmyzsh

  # Languages/toolchains
  # run init-go
  run init-python
  # run init-R
  # run init-protobuf

  # Containerization
  # run init-docker

  # run init-hashicorp

  # Check for errors at the end, which will fail out if there are any
  run check-errors

  # Run verification checks that installations/configurations went as expected
  run verify
}

if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]];  then
  run main
fi
