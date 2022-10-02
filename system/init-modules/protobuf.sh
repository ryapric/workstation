#!/usr/bin/env bash
set -euo pipefail

init-protobuf() {
  go install github.com/bufbuild/buf/cmd/buf@latest \
  || log-error 'Could not install buf!'
}
