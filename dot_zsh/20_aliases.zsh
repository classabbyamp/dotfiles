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
alias icat="kitty icat --align=left"
alias isvg="rsvg-convert -az 1.5 | convert -trim -channel RGB -negate - - | icat"
alias xevsxhkd="xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'"

if which nc > /dev/null; then
    alias pastebin="nc termbin.com 9999"
fi

if which thefuck > /dev/null; then
    eval $(thefuck --alias)
fi

