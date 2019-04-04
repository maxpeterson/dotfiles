# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

debug_bash_on=0
function debug_bash() {
    if [ "$debug_bash_on" = 1 ] ; then  
        echo "$(date "+%s.%N") - $@";
    fi
}

debug_bash "start .bash_profile"

[[ -s ~/.bashrc ]] && . ~/.bashrc

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# OSX colours
export CLICOLOR=1
export LS_COLORS='di=01;34'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    git_root=$(brew --prefix git)
    if [ -f "$git_root/etc/bash_completion.d/git-completion.bash" ]; then
        . "$git_root//etc/bash_completion.d/git-completion.bash"
    fi
    if [ -f "$git_root/etc/bash_completion.d/git-prompt.sh" ]; then
        . "$git_root/etc/bash_completion.d/git-prompt.sh"
    fi

    GREEN="\[\033[0;32m\]"
    WHITE="\[\033[0;37m\]"
    YELLOW="\[\033[0;33m\]"

    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    
    PS1="${debian_chroot:+($debian_chroot)}$GREEN\u@\h:$WHITE\W$YELLOW\$(__git_ps1)$WHITE\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\a\]$PS1"
#    ;;
#*)
#    ;;
#esac


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    debug_bash "source ~/.bash_aliases"
    . ~/.bash_aliases
    debug_bash "done ~/.bash_aliases"
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


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    debug_bash "source /etc/bash_completion"
    . /etc/bash_completion
    debug_bash "done /etc/bash_completion"
else
    brew_prefix=$(brew --prefix)
    if [ -f "${brew_prefix}/etc/profile.d/bash_completion.sh" ]; then
        debug_bash "source ${brew_prefix}/etc/profile.d/bash_completion.sh"
        . "${brew_prefix}/etc/profile.d/bash_completion.sh"
        debug_bash "done ${brew_prefix}/etc/profile.d/bash_completion.sh"
    fi
fi

export EDITOR=/usr/bin/vim

# For PIP
#export PIP_REQUIRE_VIRTUALENV=true
export ARCHFLAGS="-arch i386 -arch x86_64"

# Load RVM function
debug_bash "source $HOME/.rvm/scripts/rvm"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
debug_bash "done $HOME/.rvm/scripts/rvm"

#Solr
solr_prefix=$(brew --prefix solr)
export SOLR_CONF=${solr_prefix}/libexec/example/solr/
export SOLR_SCHEMA=${solr_prefix}/libexec/example/solr/conf/schema.xml
alias solr='solr $SOLR_CONF'

# Virtualenvwrapper
export WORKON_HOME=~/Envs
#export VIRTUALENVWRAPPER_HOOK_DIR="$HOME/dotfiles/virtualenvwrapper"
debug_bash "source /usr/local/bin/virtualenvwrapper.sh"
source /usr/local/bin/virtualenvwrapper_lazy.sh
debug_bash "done /usr/local/bin/virtualenvwrapper.sh"

if [ -f ~/.bash_profile_local ]; then
    debug_bash "source ~/.bash_profile_local"
    . ~/.bash_profile_local
    debug_bash "done ~/.bash_profile_local"
fi

export NVM_DIR=~/.nvm
debug_bash "source nvm.sh"
. $(brew --prefix nvm)/nvm.sh
debug_bash "done nvm.sh"

debug_bash "source ${HOME}/.iterm2_shell_integration.bash"
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
debug_bash "done ${HOME}/.iterm2_shell_integration.bash"


debug_bash "done .bash_profile"
