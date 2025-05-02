# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Avoid duplicates
HISTCONTROL=ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

set -o vi
alias f='find -name'
export PATH=$HOME/.local/bin:$PATH
export VISUAL=vim
export EDITOR=vim
export BYOBU_PYTHON=/usr/bin/python3 # FIXME: Change to custom built python

export PROMPT_COMMAND=genprompt
genprompt() {
  local EXIT=$?
  local GIT=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
  local RED='\[\e[0;31m\]'
  local HAPPY='\[\e[0;94m\]'
  local RESET_COLOR='\[\033[00m\]'
  PS1="\h \[\033[32m\]\w\[\033[33m\]${GIT}"
  if [ $EXIT != 0 ]; then
    PS1+=$RED
    PS1+=' ¯\_(ツ)_/¯ '
  else
    PS1+=$HAPPY
    PS1+=' > '
  fi
  PS1+=$RESET_COLOR
}

# Shorthand for cd'ing into corresponding include/lib directory for LLVM
alias cdlib="cd $(pwd | sed -E 's/([a-zA-Z0-9_\-]+)\/include\/\1/\1\/lib/')"
alias cdinc="cd $(pwd | sed -E 's/([a-zA-Z0-9_\-]+)\/lib/\1\/include\/\1/')"
