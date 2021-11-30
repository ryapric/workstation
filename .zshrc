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
  "/usr/local/go/bin" \
  "${HOME}/go/bin" \
; do
  export PATH="${p}:${PATH}"
done

### Aliases
alias aws-azure-login="docker run --rm -it -v ${HOME}/.aws:/root/.aws sportradar/aws-azure-login:latest "
alias cfn='aws cloudformation '
alias dsp='docker system prune'
alias dspv='docker system prune --volumes'
alias rhad='docker run --rm -it -v "${PWD}":/root/src opensourcecorp/rhadamanthus:latest '
alias tclsh='rlwrap tclsh '
alias tf='terraform '
alias va='source venv/bin/activate'
alias vc='python3 -m venv --clear venv'

### Vars
export AWS_DEFAULT_REGION='us-east-2'
export AWS_PROFILE=default
[[ -f "${HOME}/.aws_var_overrides" ]] && source "${HOME}/.aws_var_overrides"

export DOCKER_BUILDKIT=1

export OSC_ROOT="${HOME}/repos/opensourcecorp"
export PACKER_CACHE_DIR="${HOME}/.packer.d/packer_cache"
export VAGRANT_EXPERIMENTAL="disks"

### Functions
install-go() {
  if [[ -z "${1}" ]]; then
    printf 'ERROR: Must provide a Go version\n'
    return 1
  fi
  printf 'Downloading Go version %s...\n' "${1}"
  curl -fsSL -o /tmp/go.tar.gz https://golang.org/dl/go"${1}".linux-amd64.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
  go version || return 1
  printf 'Successfully installed Go %s!\n' "${1}"
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

### THE FOLLOWING NEED TO RUN LAST
# Check if running under WSL
if uname -a | grep -q -i -E 'microsoft|wsl'; then
  printf 'Trying to run sudo at shell start; you might be prompted for the sudo password if needed\n'
  sudo service docker start || true
fi

# This needs to run DEAD LAST, since it's an exec call
{ [[ -z "${TMUX}" ]] && exec tmux ;} || true
