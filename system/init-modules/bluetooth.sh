#!/usr/bin/env bash
set -euo pipefail

init-bluetooth() {
  # ERTM is a feature that, among other things, prevents XBox controllers from pairing over BT lol
  log-info 'Disabling Bluetooth ERTM...'
  sudo sh -c 'echo "options bluetooth disable_ertm=1" > /etc/modprobe.d/xbox_bt.conf'
  log-info 'NOTE: Bluetooth ERTM will be disabled on next reboot'
}
