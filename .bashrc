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
export BYOBU_PYTHON=/usr/bin/python3

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
