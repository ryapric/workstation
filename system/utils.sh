#!/usr/bin/env bash
set -euo pipefail

export errfile='/tmp/workstation-init-errors.log'
rm -f "${errfile}"

# Function runner wrapper, to make sure it's defined before execution. Mostly
# for use in the main function's init calls
run() {
  command -v "${@}" > /dev/null || {
    log-error "Command or function '${*}' not found or defined"
    return
  }
  "${@}"
}

# Logging utilities
log-info() {
  printf '>>> INFO:  %s\n' "$@" 2>&1
}

log-warn() {
  printf '>>> WARN:  %s\n' "$@" 2>&1
}

log-error() {
  printf '>>> ERROR: %s\n' "$@" 2>&1 | tee -a "${errfile}"
}

# Checks the error log file for entries, and will summarize recorded errors
# before exiting. This is run at the very end of the main function, but can also be called early to force failure on an unrecoverable error. Ideally though, you probably want to resist calling this within other funcs so that the full process can run
check-errors() {
  touch "${errfile}"
  if [[ $(awk 'END { print NR }' "${errfile}") -gt 0 ]]; then
    printf '\n-------------------------------------------------------------------------------\nCaptured errors summarized:\n'
    cat "${errfile}"
    rm -f "${errfile}"
    exit 1
  else
    # Wipe clean every check
    rm -f "${errfile}"
  fi
}
