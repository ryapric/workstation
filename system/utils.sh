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

# Logging utilities -- they each wrap three lines for visibility, I know it
# looks noisy
log-info() {
  printf '>>>\n>>> INFO:  %s\n>>>\n' "$@" 2>&1
}

log-warn() {
  printf '>>>\n>>> WARN:  %s\n>>>\n' "$@" 2>&1
}

log-error() {
  printf '>>>\n>>> ERROR: %s\n>>>\n' "$@" 2>&1 | tee -a "${errfile}"
}

# Checks the error log file for entries, and will summarize recorded errors
# before exiting. This is run at the very end of the main function, but can also
# be called early to force failure on an unrecoverable error. Ideally though,
# you probably want to resist calling this within other funcs so that the full
# process can run
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

# Helper func to grab APT key for a given third-party repo
get-apt-key() {
  [[ -z "${1}" ]] && { printf 'Must specify GPG key URL as first argument\n' && return 1; }
  [[ -z "${2}" ]] && { printf 'Must specify GPG key file name as second argument\n' && return 1; }
  local url="${1}"
  local keyfile="${2}"
  curl -fsSL "${url}" > /tmp/"${keyfile}"
  if file /tmp/"${keyfile}" | grep '(old)'; then
    printf 'ASCII GPG format found; dearmoring first\n'
    sudo sh -c "cat /tmp/${keyfile} | gpg --dearmor > /etc/apt/trusted.gpg.d/${keyfile}"
  else
    printf 'GPG binary format found, adding key directly\n'
    sudo cp /tmp/"${keyfile}" /etc/apt/trusted.gpg.d/"${keyfile}"
  fi
  printf 'Stored GPG key material in /etc/apt/trusted.gpg.d/%s\n' "${keyfile}"
}
