#!/usr/bin/env bash
set -euo pipefail

# Using envsubst in a single call seems to only use the last line in the file,
# so envsubst the whole thing to a separate file first
<map.txt envsubst > /tmp/map.txt

while read -r line; do
  # Skip comments and blank/malformed lines
  if grep -qE '^#' <(echo "${line}") || grep -qE '^\s+?$' <(echo "${line}"); then continue; fi

  src=$(realpath "$(awk '{ print $1 }' <<< "${line}")")
  tgt=$(awk '{ print $2 }' <<< "${line}")
  action=$(awk '{ print $3 }' <<< "${line}")

  mkdir -p "$(dirname "${tgt}")"

  maybe_sudo=''
  if [[ $(stat -c '%U' "${tgt}") == 'root' ]]; then
    # the trailing space is important so bash can run the compound command as a
    # single token later
    maybe_sudo='sudo '
  fi

  # Default to symlinking if action is empty
  if [[ -z "${action}" || "${action}" == 'link' ]]; then
    "${maybe_sudo}"ln -fs "${src}" "${tgt}"
  elif [[ "${action}" == 'copy' ]]; then
    "${maybe_sudo}"cp "${src}" "${tgt}"
  fi

  printf 'Symlinked %s to %s\n' "${src}" "${tgt}"
done < /tmp/map.txt
