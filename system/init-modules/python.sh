#!/usr/bin/env bash
set -euo pipefail

init-python() {
  log-info 'Configuring Python...'
  sudo apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
  || log-error 'Error when installing Python utilities!'

  python3 -m pip install --user --no-warn-script-location \
    ipython \
    mypy \
    pytest \
    pytest-cover \
  || log-error 'Error when installing pip packages!'
}
