export PATH=/opt/homebrew/sbin:/opt/homebrew/bin:$PATH
export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export PATH=$(python3 -m site --user-base)/bin:$PATH
export PATH=~/bin:~/scripts:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/max/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
plugins=(git virtualenvwrapper nvm rbenv)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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

ARCH=$(arch)
if [ "$ARCH" = "arm64" ]; then
  iarch () { arch -x86_64 $@ }
else
  iarch () { $@ }
  alias brew='/usr/local/bin/brew'
fi

IBREW_BIN=/usr/local/bin/brew
if [ -e $IBREW_BIN ]; then
  alias ibrew='iarch /usr/local/bin/brew'
  alias ipip='iarch pip'

  IBREW_PREFIX=$(ibrew --prefix)
  IBREW_OPT=$IBREW_PREFIX/opt
fi

export PATH=$PATH:/usr/local/heroku/bin
export PATH=$PATH:/usr/local/opt/python/libexec/bin/
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

#export CATALINA_HOME=/usr/local/tomcat6
# sqlite
SQLITE_HOME="$(brew --prefix sqlite)"
export PATH="$PATH:$SQLITE_HOME/bin"
export LDFLAGS="-L$SQLITE_HOME/lib"
export CPPFLAGS="-I$SQLITE_HOME/include"
export PKG_CONFIG_PATH="$SQLITE_HOME/lib/pkgconfig"

#export JAVA_HOME=$(/usr/libexec/java_home)

## TODO: Figure out strategy for compiling arm64 vs x86_64
##
## Required to fix compile error following Xcode upgrade to 5.1
## clang: error: unknown argument: '-mno-fused-madd' [-Wunused-command-line-argument-hard-error-in-future]
export CFLAGS=-Qunused-arguments
if [ -e $IBREW_BIN ]; then
  export LIBMEMCACHED=$IBREW_PREFIX
  # export CPPFLAGS="-Qunused-arguments -I$IBREW_OPT/zlib/include -I$IBREW_OPT/bzip2/include"
  # export LDFLAGS="-L$IBREW_OPT/zlib/lib -L$IBREW_OPT/bzip2/lib"
fi

export DYLD_FALLBACK_LIBRARY_PATH=/Applications/Postgres.app/Contents/Versions/latest/lib:$DYLD_LIBRARY_PATH


# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
setopt histappend


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.profile_local ]; then
    . ~/.profile_local
fi

export EDITOR=/usr/bin/vim

# For PIP
#export PIP_REQUIRE_VIRTUALENV=true
#export ARCHFLAGS="-arch i386 -arch x86_64"

# Setup rbenv
#eval "$(rbenv init -)"


export WORKON_HOME=~/Envs
#export VIRTUALENVWRAPPER_HOOK_DIR="$HOME/dotfiles/virtualenvwrapper"
#source /usr/local/bin/virtualenvwrapper_lazy.sh


export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Use .nvmrc on cd
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

if [ -f "${HOME}/.iterm2_shell_integration.zsh" ]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi
if [ $ITERM_SESSION_ID ]; then
  DISABLE_AUTO_TITLE="true"
  precmd() {
    echo -ne "\033]0;${PWD##*/}\007"
  }
fi

VIRTUALENVWRAPPER_PYTHON=$(which python3)

# pyenv not yet working on Apple macOS Big Sur / Silicon
# https://github.com/pyenv/pyenv/issues/1643
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    # Using pyvenv instead of virtualenv
    # https://github.com/pyenv/pyenv-virtualenvwrapper#using-pyvenv-instead-of-virtualenv
    export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
    pyenv virtualenvwrapper
fi

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platfrom-tools

# Flutter
export FLUTTER_HOME=$HOME/development/flutter
export PATH=$PATH:$FLUTTER_HOME/bin

# Kubectl

# Set the default kube context if present
DEFAULT_KUBE_CONTEXTS="$HOME/.kube/config"
if test -f "${DEFAULT_KUBE_CONTEXTS}"
then
  export KUBECONFIG="$DEFAULT_KUBE_CONTEXTS"
fi

# Additional contexts should be in ~/.kube/custom-contexts/ 
CUSTOM_KUBE_CONTEXTS="$HOME/.kube/custom-contexts"
mkdir -p "${CUSTOM_KUBE_CONTEXTS}"
while read contextFile; do
    export KUBECONFIG="$contextFile:$KUBECONFIG";
done < <(find "${CUSTOM_KUBE_CONTEXTS}" -type f -name "*.yaml")

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
