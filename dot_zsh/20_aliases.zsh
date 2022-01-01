# aliases for zsh

alias void="neofetch"
alias xrm="sudo xbps-remove"
alias ping="ping -c 3"
alias pingg="ping www.google.com"
alias ping8="ping 8.8.8.8"
alias c="clear"
alias ssh="TERM=xterm-256color ssh"
if command -v nvim &>/dev/null; then
    alias vim="nvim"
    alias vi="nvim"
    alias v="nvim"
    alias vimdiff="nvim -d"
    alias oldvim="/usr/bin/vim"
fi
alias :q="exit"
alias py="python3"
alias woman="man"
alias chm="chezmoi"
if command -v rg &>/dev/null; then
    alias grep="rg"
fi
if command -v fd &>/dev/null; then
    alias find="fd"
fi
alias gpg="gpg2"

alias vsrcupdate="git pull --rebase upstream master; ./xbps-src bootstrap-update"

if [[ "$TERM" == "xterm-kitty" ]]; then
    alias icat="kitty icat --align=left"
    alias isvg="rsvg-convert -az 1.5 | convert -trim -channel RGB -negate - - | icat"
    alias idot="dot -Tsvg -Efontname=InputMono -Efontcolor='#ffffff' -Ecolor='#ffffff' -Nfontcolor='#ffffff' -Ncolor='#ffffff' -Gbgcolor='#1e1c31' | rsvg-convert -az 1.1 | convert -trim -channel RGB - - | icat"
fi

if command -v nc &>/dev/null; then
    alias pastebin="nc termbin.com 9999"
fi

