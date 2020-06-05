if exists('g:vscode')
    set clipboard=unnamedplus
else
    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vimrc
endif
