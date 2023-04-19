#!/usr/bin/env bash
set -euo pipefail

export cmdoutput_file='/tmp/workstation-init-failed-command-output.log'
rm -f "${cmdoutput_file}"
touch "${cmdoutput_file}"

verify() {
  cmds=(
    bats
    buf
    cargo
    code
    docker
    firefox
    go
    ipython3
    irb
    mupen64plus
    mupen64plus-qt
    nano
    packer
    parallel
    pip3
    protoc
    python3
    R
    Rscript
    rstudio
    ruby
    rustc
    rustup
    steam
    terraform
    torbrowser-launcher
    vagrant
    vault
    # vboxmanage
    virsh
    virt-manager
    xfce4-about
    xfce4-terminal
    zsh
  )

  for cmd in "${cmds[@]}"; do
    command -v "${cmd}" > /dev/null \
    || log-error "Command '${cmd}' expected to be available on \$PATH, but was not"
  done

  # The 'command' builtin doesn't pick up on compound or subcommands, so check
  # those here via eval calls instead
  subcmds=(
    # 'python3 -m grpc_tools.protoc --help'
    'python3 -m http.server --help'
  )

  for subcmd in "${subcmds[@]}"; do
    eval "${subcmd}" >> "${cmdoutput_file}" 2>&1 \
    || log-error "Compound or subcommand '${subcmd}' expected to succeed, but failed. Review log file '${cmdoutput_file}' for details."
  done

  check-errors
}
