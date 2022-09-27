### ZSH stuff
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="gnzh"
plugins=(
  docker
  docker-compose
  git
  python
  ubuntu
)

source "${ZSH}/oh-my-zsh.sh"

### PATH
for p in \
  "${HOME}/.local/bin" \
  "${HOME}/.local/go/bin" \
  "${HOME}/go/bin" \
; do
  export PATH="${p}:${PATH}"
done

### Aliases
# if grep -q 'sid' /etc/*-release; then
#   printf 'Debian Sid detected; assuming you are using Podman, and will alias "docker" to that\n'
#   alias docker='sudo podman '
#   alias docker-compose='sudo podman-compose '
# fi

alias aws-azure-login="docker run --rm -it -v ${HOME}/.aws:/root/.aws docker.io/sportradar/aws-azure-login:latest "
alias cfn='aws cloudformation '
alias dsp='docker system prune'
alias dspv='docker system prune --volumes'
alias k='kubectl '
alias tclsh='rlwrap tclsh '
alias tf='terraform '
alias va='source venv/bin/activate'
alias vc='python3 -m venv --clear venv'

### Vars
export AWS_DEFAULT_REGION='us-east-2'
export AWS_PROFILE=default
[[ -f "${HOME}/.aws_var_overrides" ]] && source "${HOME}/.aws_var_overrides"

export DOCKER_BUILDKIT=1

export OSC_INFRA_ROOT="${HOME}/repos/opensourcecorp/osc-infra"
export VAGRANT_EXPERIMENTAL="disks"

### Completions
if command -v kubectl > /dev/null; then
  source <(kubectl completion zsh)
fi

### Functions
install-go() {
  if [[ -z "${1}" ]]; then
    printf 'No specific version provided, so finding latest Go version...\n'
    # Need to redirect to file first, so curl doesn't get mad about closing the pipe before the HTML is done being read
    { curl -fsSL https://go.dev/dl > /tmp/go-dl.html } || return 1
    local goversion=$(
      </tmp/go-dl.html \
        grep -o -E 'go[0-9]+\.[0-9]+(\.[0-9]+)?' \
        | sed -E 's/go//' \
        | head -n1
    )
  else
    local goversion="${1}"
  fi

  if [[ ! -f /tmp/"go${goversion}".tar.gz ]]; then
    printf 'Downloading Go version %s...\n' "${goversion}"
    { curl -fsSL -o /tmp/"go${goversion}".tar.gz https://golang.org/dl/go"${goversion}".linux-amd64.tar.gz } || return 1
    printf 'Downloaded Go version %s\n' "${goversion}"
  fi

  printf 'Cleaning up any old Go installation, and adding new one...\n'
  rm -rf "${HOME}"/.local/go || return 1
  tar -C "${HOME}"/.local --overwrite -xzf /tmp/"go${goversion}.tar.gz" || return 1

  printf 'Version check for %s: %s\n' "$(command -v go)" "$(go version)" || return 1
  printf 'Successfully installed Go %s!\n' "${goversion}"
}

get-apt-key() {
  [[ -z "${1}" ]] && { printf 'Must specify GPG key URL as first argument\n' && return 1; }
  [[ -z "${2}" ]] && { printf 'Must specify GPG key file name as second argument\n' && return 1; }
  local url="${1}"
  local keyfile="${2}"
  curl -fsSL "${url}" > /tmp/"${keyfile}"
  if file /tmp/"${keyfile}" | grep '(old)'; then
    printf 'ASCII GPG format found; dearmoring first\n'
    sudo sh -c "cat /tmp/${keyfile} | gpg --dearmor > /etc/apt/trusted.gpg.d/${keyfile}"
  else
    printf 'GPG binary format found, adding key directly\n'
    sudo cp /tmp/"${keyfile}" /etc/apt/trusted.gpg.d/"${keyfile}"
  fi
  printf 'Stored GPG key material in /etc/apt/trusted.gpg.d/%s\n' "${keyfile}"
}

# Handy SQLite func for operating directly on CSVs
csvql() {
  sqlite3 \
    ':memory:' \
    -cmd '.mode csv' \
    -cmd ".import $1 data" \
    -cmd '.mode column' \
    "${2}"
}

### THE FOLLOWING NEED TO RUN LAST
# Check if running under WSL, and NOT WSL Debian
if uname -a | grep -q -i -E 'microsoft|wsl' ; then # && ! grep -q 'sid' /etc/*-release ; then
  printf 'If Podman (or Docker) is not working in WSL due to iptables complaining, check out this link:\n'
  printf 'https://github.com/microsoft/WSL/discussions/4872#discussioncomment-99164\n'
  printf 'Trying to run sudo at shell start; you might be prompted for the sudo password if needed\n'
  sudo service docker start || true
  sudo bash -c '[[ -f /etc/resolv.conf ]] || sudo printf "nameserver 8.8.8.8\nnameserver 1.1.1.1\n" > /etc/resolv.conf'
  # export VAGRANT_DEFAULT_PROVIDER='hyperv'
fi

# This needs to run DEAD LAST, since it's an exec call
{ [[ -z "${TMUX}" ]] && exec tmux ;} || true