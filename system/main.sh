#!/usr/bin/env bash
set -euo pipefail

################################################################################
# This script serves as the root caller of the functions defined in the various
# other scripts contained in this subdirectory
################################################################################

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

here=$(dirname "$(realpath "${0}")")

# Make sure your user has passwordless sudo
sudo sh -c "printf 'ryan ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/ryan"

# Set PATH for when the directories are available to search (this is currently
# duplicated in ../dotfiles/zshrc as well)
for p in \
  "${HOME}/.local/bin" \
  "${HOME}/.local/go/bin" \
  "${HOME}/go/bin" \
  "${HOME}/.cargo/bin" \
  "/usr/games" \
  "/usr/local/games" \
; do
  if [[ ! "${PATH}" =~ ${p} ]]; then
    export PATH="${p}:${PATH}"
  fi
done

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
  run init-core

  # Shell
  run init-ohmyzsh

  # Languages/toolchains (alphabetical, no preference)
  run init-dotnet
  run init-go
  # run init-java
  run init-protobuf-grpc
  run init-python
  run init-R
  run init-rust

  # Containerization
  run init-docker

  # Virtualization
  run init-virtualization

  # HashiCorp tooling, which I might split out later
  run init-hashicorp

  # The following should only run if there is a display
  if [[ -n "${DISPLAY:-}" ]] ; then
    # Desktop environment
    run init-xfce4

    # Browser(s)
    run init-browsers

    # Editor(s)
    run init-vscode
    run init-Rstudio
    # run init-nanorc

    # Gaming software
    run init-gaming

    # Recording/streaming software
    run init-obs-studio

    # Bluetooth behavior
    run init-bluetooth
  fi

  # Run dotfiles last, so they don't get replaced by installations etc.
  run init-dotfiles

  # ============================================================================

  # Cleanup
  sudo apt-get clean
  sudo apt-get autoclean
  sudo apt-get autoremove -y

  # ============================================================================

  # Check for errors again at the end, which will fail out if there are any
  run check-errors

  # Run verification checks that installations/configurations went as expected
  log-info 'Verifying system...'
  run verify

  log-info 'All done! Workstation is ready to use!'
  log-info 'You will want to restart your machine, though, to ensure that anything that might have needed e.g. an updated kernel is working'
}

if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]];  then
  run main
fi
