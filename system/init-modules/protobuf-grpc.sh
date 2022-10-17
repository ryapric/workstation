#!/usr/bin/env bash
set -euo pipefail

init-protobuf-grpc() {
  log-info 'Installing protocol buffer & gRPC tooling...'

  sudo apt-get install -y protobuf-compiler

  go install github.com/bufbuild/buf/cmd/buf@latest \
  || log-error 'Could not install buf!'

  {
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
  } || log-error 'Could not install gRPC tooling for Go!'

  pip3 install --user \
    grpcio \
    grpcio-tools \
  || log-error 'Could not install gRPC tooling for Python!'
}
