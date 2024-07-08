#!/usr/bin/bash

function ncd {
  local path=""
  for (( i=1; i<=$1; i++ )); do
    path="../$path"
  done
  cd $path
}

alias ls='ls --color=auto --width=100'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

bind 'set bell-style none'
