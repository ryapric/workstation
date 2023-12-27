#!/usr/bin/env bash
set -euo pipefail

export cmdoutput_file='/tmp/workstation-init-failed-command-output.log'
rm -f "${cmdoutput_file}"
touch "${cmdoutput_file}"

verify() {
  # Commands that should always be present, regardless of if the install has a
  # display
  cli_cmds=(
    bats
    buf
    cargo
    docker
    dotnet
    go
    ipython3
    irb
    nano
    neofetch
    packer
    parallel
    pip3
    protoc
    python3
    R
    Rscript
    ruby
    rustc
    rustup
    terraform
    vagrant
    vault
    # vboxmanage
    virsh
    zsh
  )

  # Commands that should only be present if the install has a display
  desktop_cmds=(
    code
    dolphin-emu
    firefox
    mupen64plus
    mupen64plus-qt
    obs
    rstudio
    steam
    torbrowser-launcher
    virt-manager
    xfce4-about
    xfce4-terminal
  )

  for cmd in "${cli_cmds[@]}"; do
    command -v "${cmd}" > /dev/null \
    || log-error "Command '${cmd}' expected to be available on \$PATH, but was not"
  done

  if [[ -n "${DISPLAY:-}" ]] ; then
    for cmd in "${desktop_cmds[@]}"; do
      command -v "${cmd}" > /dev/null \
      || log-error "Command '${cmd}' expected to be available on \$PATH, but was not"
    done
  fi

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

  check-errors && log-info 'All good!'
}
