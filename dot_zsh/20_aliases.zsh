# aliases for zsh

if command -v doas &>/dev/null; then
    alias sudo="echo use doas, dummy"
    alias sudoedit="echo use doasedit, dummy"
    alias doasedit="doas $EDITOR"
    _sudo=doas
else
    _sudo=sudo
fi

alias ll='ls -l --color=auto'
alias lh='ls -lh --color=auto'
alias l.='ls -d .* --color=auto'
alias ls='ls --color=auto'
alias tree='tree -C'

alias void="neofetch"
alias ping="ping -c 3"
alias pingg="ping www.google.com"
alias ping8="ping 8.8.8.8"
alias c="clear"
alias ssh="TERM=xterm-256color ssh"
if command -v nvim &>/dev/null; then
    alias v="nvim"
    alias vimdiff="nvim -d"
    alias vdiff="nvim -d"
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

if [[ "$TERM" == "xterm-kitty" ]]; then
    alias icat="kitty icat --align=left"
    alias isvg="rsvg-convert -az 1.5 | convert -trim -channel RGB -negate - - | icat"
    alias idot="dot -Tsvg | rsvg-convert -az 1.1 | convert -trim -channel RGB - - | icat"
fi

if command -v nc &>/dev/null; then
    alias pastebin="nc termbin.com 9999"
fi

alias xrm="$_sudo xbps-remove"
alias xrevdeps="xbps-query -RX"
alias xs="./xbps-src"

function xrs() {
    command xrs $@ | grep -v '\-32bit-' | grep -v '\-dbg-'
}

function xtree() {
    xls $@ | treeify
}
compdefas xls xtree

