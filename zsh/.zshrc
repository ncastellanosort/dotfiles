# ~/.zshrc

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="$PATH:/home/nicolas/.local/bin"

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config ~/.poshthemes/robbyrussell.omp.json)"
fi
