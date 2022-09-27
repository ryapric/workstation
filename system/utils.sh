#!/usr/bin/env bash
set -euo pipefail

log-info() {
  printf '>>> INFO:  %s\n' "$@" 2>&1
}

log-warn() {
  printf '>>> WARN:  %s\n' "$@" 2>&1
}

log-error() {
  printf '>>> ERROR: %s\n' "$@" 2>&1
  exit 1
}
