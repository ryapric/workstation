#!/usr/bin/env bash
set -euo pipefail

init-go() {
  log-info 'Installing Go...'

  goversion_requested="${1:-}"
  if [[ -z "${goversion_requested}" ]]; then
    printf 'No specific version provided, so finding latest Go version...\n'
    # Need to redirect to file first, so curl doesn't get mad about closing the pipe before the HTML is done being read
    { curl -fsSL https://go.dev/dl > /tmp/go-dl.html ; } || return 1
    # shellcheck disable=SC2155
    local goversion=$(
      </tmp/go-dl.html \
        grep -o -E 'go[0-9]+\.[0-9]+(\.[0-9]+)?' \
        | sed -E 's/go//' \
        | head -n1
    )
  else
    local goversion="${goversion_requested}"
  fi

  if [[ ! -f /tmp/"go${goversion}".tar.gz ]]; then
    printf 'Downloading Go version %s...\n' "${goversion}"
    { curl -fsSL -o /tmp/"go${goversion}".tar.gz https://golang.org/dl/go"${goversion}".linux-amd64.tar.gz ; } || return 1
    printf 'Downloaded Go version %s\n' "${goversion}"
  fi

  printf 'Cleaning up any old Go installation, and adding new one...\n'
  rm -rf "${HOME}"/.local/go || return 1
  tar -C "${HOME}"/.local --overwrite -xzf /tmp/"go${goversion}.tar.gz" || return 1

  printf 'Version check for %s: %s\n' "$(command -v go)" "$(go version)" || return 1
  printf 'Successfully installed Go %s!\n' "${goversion}"
}
