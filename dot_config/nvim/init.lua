-- vim:foldmethod=marker

local o = vim.o
local g = vim.g
local cmd = vim.cmd
local keymap = vim.keymap
local void_dir = vim.fn.expand('~/void')

cmd([[
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync
    endif
]])

local Plug = vim.fn['plug#']

vim.call('plug#begin')
    -- looks
    Plug 'navarasu/onedark.nvim'
    Plug 'navarasu/onedark.nvim'
    Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
    Plug 'itchyny/lightline.vim'
    -- utilities
    Plug('lewis6991/gitsigns.nvim')
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'Raimondi/delimitMate'
    Plug 'junegunn/vim-easy-align'
    -- filetypes
    Plug 'alker0/chezmoi.vim'
    Plug('plasticboy/vim-markdown', {['for'] = 'md'})
    Plug('chrisbra/csv.vim', {['for'] = {'csv', 'tsv'}})
    Plug('jmcantrell/vim-virtualenv', {['for'] = 'python'})
    -- completion/lsp
    Plug 'neovim/nvim-lspconfig'
    Plug 'josa42/nvim-lightline-lsp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'petertriho/cmp-git'
        Plug 'nvim-lua/plenary.nvim' -- required by cmp-git
    Plug 'hrsh7th/nvim-cmp'
    Plug 'dcampos/nvim-snippy'
    Plug 'dcampos/cmp-snippy'
    -- other
    Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdateSync']})
    Plug 'HiPhish/nvim-ts-rainbow2'
vim.call('plug#end')

o.syntax = 'on'
o.number = true
o.encoding = 'utf-8'
o.hidden = true
o.autowrite = true
o.modeline = true
o.modelines = 5
o.cursorline = true
o.mouse = 'a'

o.colorcolumn = '120'
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.conceallevel = 0

o.laststatus = 2
o.showmode = false
o.incsearch = true
o.inccommand = 'nosplit'

-- Highlight unnecessary whitespace
o.list = true
o.listchars = 'tab:› ,extends:»,precedes:«,nbsp:␣,trail:·'

-- Undo
if vim.fn.has("persistent_undo") == 1 then
    o.undofile = true
end

-- Mappings
keymap.set('', ' ', '<leader>', {remap = true})
keymap.set('', '<F1>', '', {remap = true})
keymap.set('', '<c-j>', '<c-w>j', {remap = true})
keymap.set('', '<c-k>', '<c-w>k', {remap = true})
keymap.set('', '<c-h>', '<c-w>h', {remap = true})
keymap.set('', '<c-l>', '<c-w>l', {remap = true})
-- system clipboard
keymap.set({'n', 'x'}, '<leader>d', '"+d')
keymap.set({'n', 'x'}, '<leader>D', '"+D')
keymap.set({'n', 'x'}, '<leader>y', '"+y')
keymap.set({'n', 'x'}, '<leader>Y', '"+Y')
keymap.set({'n', 'x'}, '<leader>p', '"+p')
keymap.set({'n', 'x'}, '<leader>P', '"+P')
-- exit terminal mode with shift+escape
keymap.set('t', '<Esc>', '<C-\\><C-n>')

cmd('com Ws w !doas tee %')

-- colourscheme
g.onedark_config = {
    style = 'darker',
    transparent = true,
}
require('catppuccin').setup({
    flavour = 'mocha',
    transparent_background = true,
    dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.15,
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        ts_rainbow2 = true,
        native_lsp = {enabled = true}
    }
})

cmd.colorscheme('catppuccin')
o.termguicolors = true

-- filetypes
vim.filetype.add({
    extension = {
        typ = 'typst',
    },
    pattern = {
        ['${XBPS_DISTDIR}/srcpkgs/.*/template'] = 'bash',
    },
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {void_dir .. '/**'},
    callback = function(ev) o.expandtab = false end,
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = {'*.yml', '*.yaml'},
    callback = function(ev) o.expandtab = true end,
})

-- python
g.python3_host_prog = '/usr/bin/python3'

-- delimitMate
g.delimitMate_expand_cr = 1

-- Markdown
g.vim_markdown_folding_disabled = 1
g.vim_markdown_conceal = 0
g.vim_markdown_frontmatter = 1

-- lightline {{{
g.lightline = {
    colorscheme = 'catppuccin',
    mode_map = {
        ['__'] = '-',
        ['n']  = 'N',
        ['i']  = 'I',
        ['R']  = 'R',
        ['c']  = 'C',
        ['v']  = 'V',
        ['V']  = 'V-L',
        [''] = 'V-B',
        ['s']  = 'S',
        ['S']  = 'S-L',
        [''] = 'S-B',
        ['t']  = 'T',
    },
    active = {
        left = {
            {'mode', 'paste', 'lsp_errors', 'lsp_warnings'},
            {},
            {'relativepath'},
        },
        right = {
            {},
            {},
            {'fileformat', 'fileencoding', 'filetype', 'venv', 'gitstatus', 'lineinfo'},
        },
    },
    inactive = {
        left = {
            {'filename'},
        },
        right = {
            {'lineinfo'},
        },
    },
    tabline = {
        left = {
            {'tabs'},
        },
        right = {
            {},
        },
    },
    component = {
        lineinfo = '%p%% %l:%v',
        gitstatus = '%{get(b:, "gitsigns_status", "")}',
    },
    component_function = {
        relativepath = 'LightlineRelPath',
        fileformat = 'LightlineFileformat',
        filetype = 'LightlineFiletype',
        fileencoding = 'LightlineFileencoding',
        venv = 'LightlineVenv'
    },
}

-- g.lightline.lsp.indicator_ok = ''
vim.call('lightline#lsp#register')

cmd([[
    function! LightlineRelPath()
        let relpath = expand('%:f') !=# '' ? expand('%:f') : '[No Name]'
        let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
        let modified = &modifiable && &modified ? ' +' : ''
        let readonly = &ft !~? 'help' && &readonly ? '[RO] ' : ''
        return winwidth(0) > 70 ? readonly . relpath . modified : readonly . filename . modified
    endfunction

    function! LightlineVenv()
        if &ft ==? 'python'
python3 <<EOF
import sys
v = sys.version.split()[0]
vim.command("let pyversion = '%s'" % v)
EOF
            return pyversion . '/' . virtualenv#statusline()
        else
            return ''
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

-- gitsigns {{{
require('gitsigns').setup {
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 500,
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        -- Actions
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line{full=true} end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}
-- end gitsigns }}}

-- treesitter {{{
require('nvim-treesitter.configs').setup({
    ensure_installed = "all",
    sync_install = false,
    highlight = {
        enable = true,
    },
    rainbow = {
        enable = true,
        query = 'rainbow-parens',
        strategy = require('ts-rainbow').strategy.global
    },
    indent = {
        enable = true
    },
})

local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_config.typst = {
  install_info = {
    -- url = 'https://github.com/SeniorMars/tree-sitter-typst',
    -- files = {'src/parser.c', 'src/scanner.c'},
    -- branch = 'main',
    url = 'https://github.com/frozolotl/tree-sitter-typst',
    files = {'src/parser.c', 'src/scanner.cc'},
    branch = 'master',
    requires_generate_from_grammar = false,
  },
}
-- end treesitter }}}

-- completion/lsp {{{
o.completeopt = 'menu,menuone,noselect'

-- Setup snippy
require('snippy').setup({
    mappings = {
        is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
        },
        nx = {
            ['<leader>x'] = 'cut_text',
        },
    },
})

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

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            require('snippy').expand_snippet(args.body)
        end,
    },
    formatting = {
        fields = { 'kind', 'abbr' },
        format = function(_, vim_item)
            vim_item.kind = cmp_kinds[vim_item.kind] or ''
            return vim_item
        end,
    },
    mapping = {
        ['<PageUp>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<PageDown>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {'i', 's'}),
        ['<S-Tab>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            end
        end, { 'i', 's' }),
        ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'snippy' },
    }, {
        { name = 'buffer' },
    })
})

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})

require("cmp_git").setup()

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
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- xi rust-analyzer
require('lspconfig').rust_analyzer.setup {
    capabilities = capabilities
}
-- xi pyright
require('lspconfig').pyright.setup {
    capabilities = capabilities
}
-- xi bash-language-server
require('lspconfig').bashls.setup {
    capabilities = capabilities,
    filetypes = { "sh", "bash" },
    on_attach = function(client)
        local path = vim.fn.expand('%:p')
        if path:find('^' .. void_dir .. '/packages/srcpkgs') ~= nil then
            client.config.settings.bashIde.shellcheckArguments = {'-e', 'SC2034', '-e', 'SC2148', '-e', 'SC2317'}
        else
            client.config.settings.bashIde.shellcheckArguments = {}
        end
        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        return true
    end,
    settings = { bashIde = { shellcheckArguments = {} } },
}
-- xi typst-lsp
require('lspconfig').typst_lsp.setup{
    capabilities = capabilities,
    filetypes = { "typst" },
}

-- end completion-lsp }}}

