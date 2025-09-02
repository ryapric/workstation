#!/usr/bin/env bash
set -euo pipefail

# Try to make grep calls more portable between Linux and macOS, ugh
gnu_grep='grep'
if [[ "$(uname -s)" == "Darwin" ]] ; then
  gnu_grep='ggrep'
fi

# Using envsubst in a single call seems to only use the last line in the file, so envsubst the whole
# thing to a separate file first
<map.txt envsubst > /tmp/map.txt

while read -r line; do
  # Skip comments and blank/malformed lines
  if "${gnu_grep}" -qE '^#' <(echo "${line}") || "${gnu_grep}" -qE '^\s+?$' <(echo "${line}"); then continue; fi

  src=$(realpath "$(awk '{ print $1 }' <<< "${line}")")
  tgt=$(awk '{ print $2 }' <<< "${line}")
  action=$(awk '{ print $3 }' <<< "${line}")

  mkdir -p "$(dirname "${tgt}")"

  dotfile_user="${USER}"
  if [[ $(stat -c '%U' "${tgt}") == 'root' ]] || [[ $(stat -c '%U' "$(dirname "${tgt}")") == 'root' ]]; then
    dotfile_user='root'
  fi

  # Default to symlinking if action is empty
  if [[ -z "${action}" || "${action}" == 'link' ]]; then
    sudo -u "${dotfile_user}" ln -fs "${src}" "${tgt}"
    printf 'Symlinked "%s" to "%s"\n' "${src}" "${tgt}"
  elif [[ "${action}" == 'copy' ]]; then
    sudo -u "${dotfile_user}" cp -r "${src}" "${tgt}"
    printf 'Copied "%s" to "%s"\n' "${src}" "${tgt}"
  fi

  if [[ "${tgt}" =~ ${HOME} ]]; then
    printf 'Fixing user permissions for target "%s"\n' "${tgt}"
    sudo chown -R "${USER}:${USER}" "${tgt}"
  fi

done < /tmp/map.txt
