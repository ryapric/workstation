# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gnzh"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  docker
  docker-compose
  git
  python
  ubuntu
)

source "${ZSH}/oh-my-zsh.sh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# PATH
for p in \
  "${HOME}/.local/bin" \
  "/usr/local/go/bin" \
  "${HOME}/go/bin" \
; do
  export PATH="${p}:${PATH}"
done

# Aliases
alias aws-azure-login="docker run --rm -it -v ${HOME}/.aws:/root/.aws sportradar/aws-azure-login:latest "
alias cfn='aws cloudformation '
alias dsp='docker system prune'
alias dspv='docker system prune --volumes'
alias rhad='docker run --rm -it -v "${PWD}":/root/src opensourcecorp/rhadamanthus:latest '
alias tclsh='rlwrap tclsh '
alias tf='terraform '
alias va='source venv/bin/activate'
alias vc='python3 -m venv --clear venv'

# Vars
export AWS_DEFAULT_REGION='us-east-2'
export AWS_PROFILE=default
[[ -f "${HOME}/.aws_var_overrides" ]] && source "${HOME}/.aws_var_overrides"

export OSC_ROOT="${HOME}/repos/opensourcecorp"
export PACKER_CACHE_DIR="${HOME}/.packer.d/packer_cache"
export VAGRANT_EXPERIMENTAL="disks"

# Functions
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
  url="${1}"
  keyfile="${2}"
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

# THE FOLLOWING NEED TO RUN LAST
# Check if running under WSL
if uname -a | grep -q -i -E 'microsoft|wsl'; then
  printf 'Trying to run sudo at shell start; you might be prompted for the sudo password if needed\n'
  sudo service docker start || true
fi

# This needs to run DEAD LAST, since it's an exec call
{ [[ -z "${TMUX}" ]] && exec tmux ;} || true
