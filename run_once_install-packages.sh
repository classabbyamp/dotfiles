#!/bin/sh

sudo xbps-install -S \
    xtools zsh neovim python3-neovim fd ripgrep zsh-syntax-highlighting \
    delta neofetch openbsd-netcat git curl

mkdir -p $HOME/.local/bin
curl https://leahneukirchen.org/dotfiles/bin/unpatch > $HOME/.local/bin/unpatch
chmod +x $HOME/.local/bin/unpatch

