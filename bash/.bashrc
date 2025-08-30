#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if command -v tmux &> /dev/null; then
  [ -z "$TMUX" ] && exec tmux
fi

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export TERM=tmux-256color

. "$HOME/.cargo/env"

# Created by `pipx` on 2025-08-17 16:45:22
export PATH="$PATH:/home/nicolas/.local/bin"

