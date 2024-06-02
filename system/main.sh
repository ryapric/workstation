#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update && sudo apt-get install -y \
  ansible-core \
  ansible-lint \
  make \
  sudo

src="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
sudo -u ryan make -C "${src}" system-config
# TODO: only runs desktop init during tests, but need a way to do this more
# dynamically as well
if [[ -n "${TESTING}" ]] ; then
  sudo -u ryan make -C "${src}" system-config-desktop-only
fi
