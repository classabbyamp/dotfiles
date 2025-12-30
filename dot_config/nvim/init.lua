local o = vim.o
local g = vim.g
local opt = vim.opt
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
        if g.neovide then
            api.nvim_set_hl(0, 'Normal', { fg = '#cdd6f4', bg = '#11111b' })
        end
    end
})

g.typst_pdf_viewer = "sioyek"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
opt.rtp = opt.rtp ^ lazypath

require('lazy').setup({
    spec = {
        { import = "plugins" },
    },
    rocks = { enabled = false },
})

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

o.modeline = true

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
    leadmultispace = '▏   ',
    multispace = '·',
    trail = '·',
}

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
-- lsp
keymap.set('n', '<F1>', vim.diagnostic.open_float)
keymap.set('n', '<F2>', vim.lsp.buf.rename)
keymap.set('n', '<F3>', vim.lsp.buf.code_action)
keymap.set('n', '[d', vim.diagnostic.goto_prev)
keymap.set('n', ']d', vim.diagnostic.goto_next)
keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true, noremap = true })
keymap.set('n', 'gD', vim.lsp.buf.declaration)
keymap.set('n', 'gd', vim.lsp.buf.definition)
keymap.set('n', 'gr', vim.lsp.buf.references)
-- telescope
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, {})
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, {})

-- filetypes
vim.filetype.add({
    extension = {
        typ = 'typst',
        typst = 'typst',
        nomad = 'hcl',
        tf = 'hcl',
        bats = 'bash',
    },
    filename = {
        ['template'] = function(_, bufnr)
            local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
            if vim.regex('\\c^# template file for'):match_str(line) ~= nil then
                return 'srcpkg'
            end
        end
    },
    pattern = {
        ['.*'] = function(_, bufnr)
            local line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ''
            if vim.regex('\\c^#!ipxe'):match_str(line) ~= nil then
                return 'ipxe'
            end
        end
    },
})

vim.treesitter.language.register('bash', 'srcpkg')

-- create parent dirs if they don't already exist
autocmd({'BufWritePre', 'FileWritePre'}, {
    callback = function(ev)
        if ev.match:match("^%w%w+://") then return end
        local file = vim.uv.fs_realpath(ev.match) or ev.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end
})

-- config for floating windows
o.winborder = "single"

local hover_cfg = {
    border = "single",
    max_height = 30,
    max_width = 80,
}

vim.lsp.buf.hover(hover_cfg)
vim.lsp.buf.signature_help(hover_cfg)

vim.diagnostic.config({
    float = { border = o.winborder },
    virtual_text = true,
    virtual_lines = { current_line = true },
})

-- show diagnostics in expanded format only on the current line
-- and at the end for other lines
vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
     group = vim.api.nvim_create_augroup('diagnostic_virt_text_hide', {}),
  callback = function(ev)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local lnum = cursor_pos[1] - 1

   local hidden_lnum = vim.b[ev.buf].diagnostic_hidden_lnum
   if hidden_lnum and hidden_lnum ~= lnum then
     vim.b[ev.buf].diagnostic_hidden_lnum = nil
     -- display all the decorations if the current line changed
     vim.diagnostic.show(nil, ev.buf)
   end

   for _, namespace in pairs(vim.diagnostic.get_namespaces()) do
     local ns_id = namespace.user_data.virt_text_ns
       if ns_id then
         local extmarks = vim.api.nvim_buf_get_extmarks(ev.buf, ns_id, { lnum, 0 }, { lnum, -1 }, {})
         for _, extmark in pairs(extmarks) do
           local id = extmark[1]
           vim.api.nvim_buf_del_extmark(ev.buf, ns_id, id)
         end

         if extmarks and not vim.b[ev.buf].diagnostic_hidden_lnum then
           vim.b[ev.buf].diagnostic_hidden_lnum = lnum
        end
      end
    end
  end,
})

-- redraw diagnostics on mode change
vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('diagnostic_redraw', {}),
  callback = function()
    pcall(vim.diagnostic.show)
  end
})

if g.neovide then
    o.guifont = "Berkeley Mono,Symbols Nerd Font,Noto Color Emoji:h10"
else
    vim.g.clipboard = 'osc52'
end

require('lspconfig.ui.windows').default_options = float_border

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_border)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_border)

require('dynlms')
