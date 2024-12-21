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
    # single token later -- you'll also notice there is no space between
    # maybe_sudo and the following commands below
    maybe_sudo='sudo '
  fi

  # Default to symlinking if action is empty
  if [[ -z "${action}" || "${action}" == 'link' ]]; then
    "${maybe_sudo}"ln -fs "${src}" "${tgt}"
    printf 'Symlinked "%s" to "%s"\n' "${src}" "${tgt}"
  elif [[ "${action}" == 'copy' ]]; then
    "${maybe_sudo}"cp -r "${src}" "${tgt}"
    printf 'Copied "%s" to "%s"\n' "${src}" "${tgt}"
  fi

  if [[ "${tgt}" =~ ${HOME} ]]; then
    printf 'Fixing user permissions for target "%s"\n' "${tgt}"
    sudo chown -R "${USER}:${USER}" "${tgt}"
  fi

done < /tmp/map.txt

# Add the git-status shell prompt helper to the homedir, since the prompt uses it
curl -fsSL -o "${HOME}/.git-prompt.sh" 'https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/completion/git-prompt.sh'
