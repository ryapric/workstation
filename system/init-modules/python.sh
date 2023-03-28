#!/usr/bin/env bash
set -euo pipefail

init-python() {
  log-info 'Configuring Python...'
  sudo apt-get install -y \
    python3 \
    ipython3 \
    python3-mypy \
    python3-pip \
    python3-pytest \
    python3-pytest-cov \
    python3-venv \
  || log-error 'Error when installing Python utilities!'
}
