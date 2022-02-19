-- vim:foldmethod=marker

vim.cmd([[
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync
    endif
]])

local Plug = vim.fn['plug#']

vim.call('plug#begin')
    -- looks
    Plug 'navarasu/onedark.nvim'
    Plug 'itchyny/lightline.vim'
    -- utilities
    Plug 'tanvirtin/vgit.nvim'
        Plug 'nvim-lua/plenary.nvim' -- required by vgit
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'Raimondi/delimitMate'
    Plug 'junegunn/vim-easy-align'
    -- filetypes
    Plug('plasticboy/vim-markdown', {['for'] = 'md'})
    Plug('chrisbra/csv.vim', {['for'] = {'csv', 'tsv'}})
    Plug('jmcantrell/vim-virtualenv', {['for'] = 'python'})
    -- completion/lsp
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    -- other
    Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})
    Plug 'p00f/nvim-ts-rainbow'
vim.call('plug#end')

vim.cmd([[syntax on]])
vim.o.number = true
vim.o.encoding = 'utf-8'
vim.o.hidden = true
vim.o.autowrite = true
vim.o.modeline = true
vim.o.modelines = 5
vim.o.cursorline = true

vim.o.tw = 120
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.conceallevel = 0

vim.o.laststatus = 2
vim.o.showmode = false
vim.o.incsearch = true
vim.o.inccommand = 'nosplit'

vim.cmd([[
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
    map <space> <leader>
    map <F1> <nop>
    map <c-j> <c-w>j
    map <c-k> <c-w>k
    map <c-h> <c-w>h
    map <c-l> <c-w>l
    " system clipboard
    nnoremap <leader>d "+d
    xnoremap <leader>d "+d
    nnoremap <leader>D "+D
    xnoremap <leader>D "+D
    nnoremap <leader>y "+y
    xnoremap <leader>y "+y
    nnoremap <leader>Y "+Y
    xnoremap <leader>Y "+Y
    nnoremap <leader>p "+p
    xnoremap <leader>p "+p
    nnoremap <leader>P "+P
    xnoremap <leader>P "+P
    " exit terminal mode with shift+escape
    tnoremap <Esc> <C-\><C-n>
    com Wsudo w !sudo tee %

    let g:onedark_config = {
    \    'style': 'darker',
    \    'transparent': v:true,
    \}
    colorscheme onedark
    set termguicolors

    " xbps-src templates
    autocmd BufNewFile,BufRead template :set ft=sh

    " delimitMate
    let delimitMate_expand_cr = 1

    " Markdown
    au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><CR>
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_frontmatter = 1
]])

-- lightline {{{
vim.cmd([[
    let g:lightline = {
    \     'colorscheme': 'one',
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
v = ".".join([ str(x) for x in sys.version_info[0:3] ])
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
]])
-- end lightline }}}

-- vgit {{{
require('vgit').setup({
  settings = {
    live_blame = {
      enabled = true,
      format = function(blame, git_config)
        local config_author = git_config['user.name']
        local author = blame.author
        if config_author == author then
          author = 'You'
        end
        local time = os.difftime(os.time(), blame.author_time)
          / (60 * 60 * 24 * 30 * 12)
        local time_divisions = {
          { 1, 'years' },
          { 12, 'months' },
          { 30, 'days' },
          { 24, 'hours' },
          { 60, 'minutes' },
          { 60, 'seconds' },
        }
        local counter = 1
        local time_division = time_divisions[counter]
        local time_boundary = time_division[1]
        local time_postfix = time_division[2]
        while time < 1 and counter ~= #time_divisions do
          time_division = time_divisions[counter]
          time_boundary = time_division[1]
          time_postfix = time_division[2]
          time = time * time_boundary
          counter = counter + 1
        end
        local commit_message = blame.commit_message
        if not blame.committed then
          author = 'You'
          commit_message = 'Uncommitted changes'
          return string.format(' %s • %s', author, commit_message)
        end
        local max_commit_message_length = 255
        if #commit_message > max_commit_message_length then
          commit_message = commit_message:sub(1, max_commit_message_length) .. '...'
        end
        return string.format(
          ' %s, %s • %s',
          author,
          string.format(
            '%s %s ago',
            time >= 0 and math.floor(time + 0.5) or math.ceil(time - 0.5),
            time_postfix
          ),
          commit_message
        )
      end,
    },
  }
})
-- end vgit }}}

-- treesitter {{{
require('nvim-treesitter.configs').setup({
    ensure_installed = "maintained",
    sync_install = false,
    highlight = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
})
-- end treesitter }}}

-- completion/lsp {{{
vim.o.completeopt = 'menu,menuone,noselect'

-- Setup nvim-cmp
local cmp = require('cmp')
local cmp_kinds = {
    Text = ' ',
    Method = ' ',
    Function = ' ',
    Constructor = ' ',
    Field = ' ',
    Variable = ' ',
    Class = ' ',
    Interface = ' ',
    Module = ' ',
    Property = ' ',
    Unit = ' ',
    Value = ' ',
    Enum = ' ',
    Keyword = ' ',
    Snippet = ' ',
    Color = ' ',
    File = ' ',
    Reference = ' ',
    Folder = ' ',
    EnumMember = ' ',
    Constant = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' ',
}

cmp.setup({
snippet = {},
formatting = {
    fields = { "kind", "abbr" },
    format = function(_, vim_item)
        vim_item.kind = cmp_kinds[vim_item.kind] or ""
        return vim_item
    end,
},
mapping = {
    ['<PageUp>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<PageDown>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
},
sources = cmp.config.sources({
    { name = 'nvim_lsp' },
}, {
    { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
sources = {
    { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
sources = cmp.config.sources({
    { name = 'path' }
}, {
    { name = 'cmdline' }
})
})

-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- xi rust-analyzer
require('lspconfig').rust_analyzer.setup {
    capabilities = capabilities
}
-- xi nodejs; sudo npm install -g pyright
require('lspconfig').pyright.setup {
    capabilities = capabilities
}

-- end completion-lsp }}}
