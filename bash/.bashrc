#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export POSH_THEMES_PATH="$HOME/.poshthemes"
export PATH=$PATH:/usr/local/bin
eval "$(oh-my-posh init bash)"
export POSH_THEME="$HOME/.poshthemes/themes/robbyrussell.omp.json"

export HYPRSHOT_DIR="$HOME/Pictures"
export TERM=tmux-256color

. "$HOME/.cargo/env"
