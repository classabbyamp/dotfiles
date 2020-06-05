if exists('g:vscode')
    call plug#begin()
    Plug 'tpope/vim-commentary'
    call plug#end()

    set clipboard=unnamedplus

    " Tab colors
    hi TabLineSel ctermbg=0

    " Highlight unnecessary whitespace
    set list listchars=tab:›\ ,extends:»,precedes:«,nbsp:␣,trail:·
    highlight ExtraWhitespace ctermbg=0
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    " python
    let g:python3_host_prog = "/home/abby/.nvimenv/bin/python"
else
    call plug#begin()
    " looks
    Plug 'challenger-deep-theme/vim', {'as': 'challenger-deep'}
    Plug 'itchyny/lightline.vim'
    " utilities
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'Raimondi/delimitMate'
    Plug 'junegunn/vim-easy-align'
    " filetypes
    Plug 'plasticboy/vim-markdown', {'for': 'md'}
    Plug 'lervag/vimtex', {'for': 'latex'}
    Plug 'vim-pandoc/vim-pandoc', {'for': 'pandoc'}
    Plug 'vim-pandoc/vim-pandoc-syntax', {'for': 'pandoc'}
    Plug 'chrisbra/csv.vim', {'for': ['csv', 'tsv']}
    Plug 'jmcantrell/vim-virtualenv', {'for': 'python'}
    " completion/lsp
    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'
    Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
    " ncm2 sources
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    Plug 'ncm2/ncm2-jedi', {'for': 'python'}
    Plug 'ncm2/ncm2-cssomni', {'for': 'css'}
    call plug#end()

    syntax on
    set nocompatible
    set number
    set encoding=utf-8
    set hidden
    set autowrite
    set modeline modelines=5
    set cursorline

    set tw=120
    set tabstop=4 shiftwidth=4 expandtab
    set conceallevel=0

    set laststatus=2
    set noshowmode
    if !has('gui_running')
        set t_Co=256
    endif

    set incsearch
    set inccommand=nosplit

    " Tab colors
    hi TabLineSel ctermbg=0

    " Highlight unnecessary whitespace
    set list listchars=tab:›\ ,extends:»,precedes:«,nbsp:␣,trail:·
    highlight ExtraWhitespace ctermbg=0
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    " Highlight TODO, FIXME
    syn match myTodo contained "\<\(TODO\|FIXME\|NOTE\|OPTIMIZE\)"

    " Undo
    if has("persistent_undo")
        set undofile
    endif

    " Mappings
    map ; <leader>
    map <F1> <nop>
    map <c-j> <c-w>j
    map <c-k> <c-w>k
    map <c-h> <c-w>h
    map <c-l> <c-w>l
    " exit terminal mode with shift+escape
    tnoremap <Esc> <C-\><C-n>
    com Wsudo w !sudo tee %

    colorscheme challenger_deep
    if has('nvim') || has('termguicolors')
        set termguicolors
    endif

    " python
    let g:python3_host_prog = "/home/abby/.nvimenv/bin/python"

    " lightline
    let g:lightline = {
    \     'colorscheme': 'challenger_deep',
    \     'mode_map': {
    \         '__' : '-',
    \         'n'  : 'N',
    \         'i'  : 'I',
    \         'R'  : 'R',
    \         'c'  : 'C',
    \         'v'  : 'V',
    \         'V'  : 'V-L',
    \         '' : 'V-B',
    \         's'  : 'S',
    \         'S'  : 'S-L',
    \         '' : 'S-B',
    \         't'  : 'T',
    \     },
    \     'active': {
    \         'left': [
    \             ['mode', 'paste'],
    \             [],
    \             ['relativepath'],
    \         ],
    \         'right': [
    \             [],
    \             [],
    \             ['fileformat', 'fileencoding', 'filetype', 'venv', 'gitstatus', 'lineinfo'],
    \         ],
    \     },
    \     'inactive': {
    \         'left': [
    \             ['filename'],
    \         ],
    \         'right': [
    \             ['lineinfo'],
    \         ],
    \     },
    \     'tabline': {
    \         'left': [
    \             ['tabs'],
    \         ],
    \         'right': [
    \             [],
    \         ],
    \     },
    \     'component': {
    \         'lineinfo': '%p%% %l:%v',
    \     },
    \     'component_function': {
    \         'gitstatus': 'LightlineGitStatus',
    \         'relativepath': 'LightlineRelPath',
    \         'fileformat': 'LightlineFileformat',
    \         'filetype': 'LightlineFiletype',
    \         'fileencoding': 'LightlineFileencoding',
    \         'venv': 'LightlineVenv'
    \     },
    \ }

    function! LightlineRelPath()
        let relpath = expand('%:f') !=# '' ? expand('%:f') : '[No Name]'
        let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
        let modified = &modifiable && &modified ? ' +' : ''
        let readonly = &ft !~? 'help' && &readonly ? '[RO] ' : ''
        return winwidth(0) > 70 ? readonly . relpath . modified : readonly . filename . modified
    endfunction

    function! LightlineGitStatus()
        if exists('*FugitiveHead')
            let branch = FugitiveHead()
            if branch !=? ''
                let [a,m,r] = GitGutterGetHunkSummary()
                return printf('<%s> +%d ~%d -%d', branch, a, m, r)
            endif
        endif
        return ''
    endfunction

    function! LightlineVenv()
        if &ft ==? 'python'
python3 << EOF
import sys
v = ".".join([str(x) for x in sys.version_info[0:3]])
vim.command("let pyversion = '%s'" % v)
EOF
            return pyversion . '/' . virtualenv#statusline()
        endif
    endfunction

    function! LightlineFileformat()
        return winwidth(0) > 70 ? (&fileformat !=? 'unix' ? &fileformat : '') : ''
    endfunction

    function! LightlineFiletype()
        return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
    endfunction

    function! LightlineFileencoding()
        let encoding = &fenc !=# '' ? &fenc : &enc
        return winwidth(0) > 70 ? (encoding !=? 'utf-8' ? encoding : '') : ''
    endfunction

    " delimitMate
    let delimitMate_expand_cr = 1

    " Markdown
    au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><CR>
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_frontmatter = 1

    " Vimtex
    au FileType latex map <C-t> :VimtexTocToggle<CR>
    let g:vimtex_compiler_progname = 'nvr'
    let g:vimtex_view_method = 'zathura'
    let g:airline#extensions#vimtex#enabled = 1
    let g:vimtex_fold_enabled = 1
    let g:tex_conceal = 'abdmgs'
    let g:vimtex_compiler_tectonic = { 'backend' : 'nvim' }

    " Pandoc
    let g:pandoc#command#custom_open = 'MyPandocOpen'
    function! MyPandocOpen(file)
        return 'zathura ' . shellescape(expand(a:file,':p'))
    endfunction
    com PandocInsModeline :normal Go[modeline]: # ( vim: set ft=pandoc: )<ESC>

    let g:pandoc#biblio#sources = "bcg"
    let g:pandoc#filetypes#handled = ["pandoc"]
    let g:pandoc#filetypes#pandoc_markdown = 0
    let g:pandoc#formatting#mode = 'hA'
    let g:pandoc#command#autoexec_on_writes = 1
    let g:pandoc#command#autoexec_command = 'Pandoc pdf -s'
    com PandocOpen Pandoc! pdf -s

    " ncm2
    autocmd BufEnter * call ncm2#enable_for_buffer()
    set completeopt=noinsert,menuone,noselect
    set shortmess+=c
    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    " LanguageClient-neovim
    let g:LanguageClient_serverCommands = {
        \ 'python': ['/usr/bin/pyls'],
        \ }
    let g:LanguageClient_settingsPath = ".vim/settings.json"
    let g:LanguageClient_loadSettings = 1
    nnoremap <F5> :call LanguageClient_contextMenu()<CR>
endif
