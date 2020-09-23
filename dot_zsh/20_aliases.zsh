# aliases for zsh

alias arch="neofetch"
alias ping="ping -c 3"
alias pingg="ping www.google.com"
alias ping8="ping 8.8.8.8"
alias c="clear"
alias ssh="TERM=xterm ssh"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias vimdiff="nvim -d"
alias oldvim="/usr/bin/vim"
alias :q="exit"
alias py="python"
alias woman="man"
alias chm="chezmoi"

if which thefuck > /dev/null; then
    eval $(thefuck --alias)
fi

