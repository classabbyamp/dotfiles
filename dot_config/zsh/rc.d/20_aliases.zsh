# aliases for zsh

if command -v doas &>/dev/null; then
    alias doasedit="doas $EDITOR"
    _sudo=doas
else
    _sudo=sudo
fi

alias ll='ls -l --color=auto'
alias lh='ls -lh --color=auto'
alias l.='ls -d .* --color=auto'
alias ls='ls --color=auto'
alias treeify='tree --noreport --fflinks --fromfile .'

alias ip='ip --color=auto'

alias void="neofetch"
alias ping="ping -c 3"
alias pingg="ping www.google.com"
alias ping8="ping 8.8.8.8"
alias c="clear"
alias ssh="TERM=xterm-256color ssh"
if command -v nvim &>/dev/null; then
    alias v="nvim -p"
    alias vimdiff="nvim -d"
    alias vdiff="nvim -d"
fi
alias :q="exit"
alias py="python3"
alias chm="chezmoi"

if [[ "$TERM" == "xterm-kitty" ]]; then
    alias icat="kitty icat --align=left"
    alias isvg="rsvg-convert -az 1.5 | convert -trim -channel RGB -negate - - | icat"
    alias idot="dot -Tsvg | rsvg-convert -az 1.1 | convert -trim -channel RGB - - | icat"
fi

alias xrm="$_sudo xbps-remove"
alias xrevdeps="xbps-query -RX"
alias xdeps="xbps-query -Rx"
alias xchl="xchangelog"

function xrs() {
    command xrs $@ | grep -v '\-32bit-' | grep -v '\-dbg-'
}

alias forkup="git pull --rebase upstream master"

alias g='git'

alias ga='git add'

alias gb='git branch'

alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'
alias gcb='git switch -c'
alias gcl='git clone --recursive'
alias gco='git switch'

alias gd='git diff'

alias gf='git fetch'
alias gfa='git fetch --all --prune'

alias glog='git log --graph --date=short --pretty="%C(auto)[%cd] %h%d %s (%aN <%aE>)"'

alias gl='git pull'
alias gp='git push'

alias gr='git remote'
alias grv='git remote -v'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'

alias gss='git status -s'
alias gst='git status'

alias gsh='git show'
