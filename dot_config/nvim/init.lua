local o = vim.o
local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local api = vim.api
local keymap = vim.keymap
local void_dir = vim.fn.expand('~/void')

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        -- don't let semantic highlights fuck up the custom highlight
        api.nvim_set_hl(0, '@lsp.type.comment', {})
        -- oranj
        api.nvim_set_hl(0, '@text.todo.comment', { fg = '#FF4F00', bold = true })
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

-- TODO: fixme
cmd('com Ws w !doas tee %')

-- filetypes
vim.filetype.add({
    extension = {
        typ = 'typst',
        nomad = 'hcl',
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

api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {void_dir .. '/**'},
    callback = function() o.expandtab = false end,
})

api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {'*.yml', '*.yaml'},
    callback = function() o.expandtab = true end,
})

-- create parent dirs if they don't already exist
api.nvim_create_autocmd({'BufWritePre', 'FileWritePre'}, {
    callback = function(ev)
        if ev.match:match("^%w%w+://") then return end
        local file = vim.loop.fs_realpath(ev.match) or ev.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end
})

-- delimitMate
g.delimitMate_expand_cr = 1

-- Markdown
g.vim_markdown_folding_disabled = 1
g.vim_markdown_conceal = 0
g.vim_markdown_frontmatter = 1
