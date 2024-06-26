#!/bin/bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

################################
# History
################################
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=100000
HISTFILESIZE=200000
# add command into .bash_history immediately, not with the end of the session
# useful with multiple sessions
PROMPT_COMMAND='history -a;history -n'
export HISTTIMEFORMAT='%F %T ' # log with datestamp


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

################################
# PS1 and colors
################################
# more about PS1 http://habrahabr.ru/post/269967/
# func to set prompt
set_prompt () {
    Last_Command=$? # Must come first!
    Blue='\[\e[01;34m\]'
    White='\[\e[01;37m\]'
    Red='\[\e[01;31m\]'
    Green='\[\e[01;32m\]'
    Reset='\[\e[00m\]'
    FancyX='\342\234\227'
    Checkmark='\342\234\223'


    # Add date
    PS1="\t "


    # Add a bright white exit status for the last command
    #PS1+="$White\$? "

    # If it was successful, print a green check mark. Otherwise, print
    # a red X.
    if [[ $Last_Command == 0 ]]; then
        PS1+="$Green$Checkmark "
    else
        PS1+="$Red$FancyX "
    fi
    # If root, just print the host in red. Otherwise, print the current user
    # and host in green.
    #if [[ $EUID == 0 ]]; then
    #    PS1+="$Red\\h "
    #else
    #    PS1+="$Green\\u@\\h "
    #fi

    # Print the working directory in blue and reset
    # the text color to the default
    PS1+="$Blue\\w$Reset "
    # git status parse

    GIT_NOT_FOUND=""                  #Nothing
    GIT_PROMPT_STAGED="${White}● "    # staged files/directories
    GIT_PROMPT_CLEAN="${White}✔ "     # clean repo

    # are we on repo?
    if [[ "$(git rev-parse --git-dir 2> /dev/null)" = '.git' ]]; then
        # on repo

        # create msg to print about repo
        GIT_MSG=""

        # check branch
        GIT_BRANCH=`git branch | grep \* | cut -c3-`
        GIT_MSG+="$GIT_BRANCH "

        # get msg len
        # +2 is for PROMPT sig
        MSG_LEN=$(( ${#GIT_MSG} + 2 ))

        # check status
        GIT_STATUS=`git status --porcelain 2> /dev/null`
        if [[ -z $GIT_STATUS ]]; then
            GIT_MSG+=$GIT_PROMPT_CLEAN
        else
            GIT_MSG+="$GIT_PROMPT_STAGED"
        fi

        # move to right modifier
        # uses tput to move next message to position (right - MSG_LEN)
        toend=$(tput hpa $(tput cols))$(tput cub $MSG_LEN)
        PS1+="${toend}${GIT_MSG}"
    else
        # not on repo
        PS1+=$GIT_NOT_FOUND
    fi
    # reset colors; add newline and $ sign
    PS1+="$Reset\n≽≽≽ "
    #PS1+="$Reset\n>>> "
}

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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
    #PS1='\t ${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PROMPT_COMMAND='set_prompt'
else
    PS1='\t ${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dmesg='dmesg --color=always'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias gcc='gcc -fdiagnostics-color=always'
fi

################################
# alias
################################

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# vi-mode breaks ctrl-L to clear screen
# fix it in .inputrc
#set -o vi # vi-mode
