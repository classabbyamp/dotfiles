# aliases for zsh

alias void="neofetch"
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
alias grep="rg"
alias gpg="gpg2"

alias vsrcupdate="git pull --rebase upstream master; ./xbps-src bootstrap-update"

alias icat="kitty icat --align=left"
alias isvg="rsvg-convert -az 1.5 | convert -trim -channel RGB -negate - - | icat"
alias idot="dot -Tsvg -Efontname=InputMono -Efontcolor='#ffffff' -Ecolor='#ffffff' -Ncolor='#ffffff' -Gbgcolor='#1e1c31' | rsvg-convert -az 1.1 | convert -trim -channel RGB - - | icat"
alias xevsxhkd="xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'"

if which nc > /dev/null; then
    alias pastebin="nc termbin.com 9999"
fi

