local o = vim.o
local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local keymap = vim.keymap
local autocmd = vim.api.nvim_create_autocmd

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- better todo comment colouring
autocmd('ColorScheme', {
    callback = function()
        -- don't let semantic highlights fuck up the custom highlight
        api.nvim_set_hl(0, '@lsp.type.comment', {})
        -- BUG ERROR FIXME(you): lol
        api.nvim_set_hl(0, '@comment.error.comment', { fg = '#c8102e', bold = true })
        -- TODO WIP
        api.nvim_set_hl(0, '@comment.todo.comment', { fg = '#ff4f00', bold = true })
        -- FIX HACK WARNING WARN
        api.nvim_set_hl(0, '@comment.warning.comment', { fg = '#ffd100', bold = true })
        -- XXX NOTE INFO DOCS PERF TEST: idk #10
        api.nvim_set_hl(0, '@comment.note.comment', { fg = '#0072ce', bold = true })
    end
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

o.syntax = 'on'
o.number = true
o.colorcolumn = '120'
o.cursorline = true
o.conceallevel = 0
o.laststatus = 2
o.showmode = false

o.encoding = 'utf-8'

o.hidden = true
o.autowrite = true
o.autoread = false
o.confirm = true

o.undofile = true

o.modeline = false

o.mouse = 'ar'

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.incsearch = true
o.inccommand = 'nosplit'
o.ignorecase = true
o.smartcase = true

o.completeopt = 'menu,menuone,noselect'

o.list = true
opt.listchars = {
    tab = '› ',
    extends = '»',
    precedes = '«',
    nbsp = '␣',
    leadmultispace = '│   ',
    multispace = '·',
    trail = '·',
}

g.python3_host_prog = '/usr/bin/python3'

-- Mappings
keymap.set('', ' ', '<leader>', {remap = true})
-- better split navigation
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
-- rename symbol
keymap.set('', '<F2>', vim.lsp.buf.rename)
-- navigate diagnostics
vim.keymap.set('n', '<F1>', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- TODO: fixme
-- cmd('com Ws w !doas tee %')

-- filetypes
vim.filetype.add({
    extension = {
        typ = 'typst',
        nomad = 'hcl',
        bats = 'bash',
    },
    filename = {
        ['template'] = function(_, bufnr)
            local line = vim.filetype.getlines(bufnr, 1):lower()
            if line:find('^# template file for') then
                return 'srcpkg'
            end
        end
    },
})

vim.treesitter.language.register('bash', 'srcpkg')

autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {vim.fn.expand('~/void') .. '/**'},
    callback = function() o.expandtab = false end,
})

autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {'*.yml', '*.yaml'},
    callback = function() o.expandtab = true end,
})

-- create parent dirs if they don't already exist
autocmd({'BufWritePre', 'FileWritePre'}, {
    callback = function(ev)
        if ev.match:match("^%w%w+://") then return end
        local file = vim.loop.fs_realpath(ev.match) or ev.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end
})

-- borders for floating windows
local float_border = { border = 'single' }

vim.diagnostic.config({ float = float_border })

require('lspconfig.ui.windows').default_options = float_border

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_border)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_border)
