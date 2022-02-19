" minimal config for vscode-neovim

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync
endif

call plug#begin()
    Plug 'tpope/vim-surround'
call plug#end()

set clipboard=unnamedplus

xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

