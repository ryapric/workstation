#!/usr/bin/env bash
set -euo pipefail

# Using envsubst in a single call seems to only use the last line in the file,
# so envsubst the whole thing to a separate file first
<map.txt envsubst > /tmp/map.txt

while read -r line; do
  if grep -qE '^#' <(echo "${line}"); then continue; fi

  src=$(realpath $(cut <(echo "${line}") -d' ' -f1))
  tgt=$(cut <(echo "${line}") -d' ' -f2)

  mkdir -p $(dirname "${tgt}")

  if [[ $(stat -c '%U' "${tgt}") == 'root' ]]; then
    sudo ln -fs "${src}" "${tgt}"
  else
    ln -fs "${src}" "${tgt}"
  fi

  printf 'Symlinked %s to %s\n' "${src}" "${tgt}"
done < /tmp/map.txt
