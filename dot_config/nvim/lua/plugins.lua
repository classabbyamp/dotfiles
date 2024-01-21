return {
    -- looks
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        priority = 1000,
        config = require('cfg.colorscheme'),
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = require('cfg.lualine'),
    },
    -- utilities
    {
        'lewis6991/gitsigns.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = require('cfg.gitsigns'),
    },
    'tpope/vim-surround',
    'tpope/vim-commentary',
    -- TODO: replace with
    -- https://github.com/windwp/nvim-autopairs
    -- https://github.com/abecodes/tabout.nvim
    'Raimondi/delimitMate',
    'junegunn/vim-easy-align',
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = 'nvim-tree/nvim-web-devicons',
        keys = {
            {'<c-n>', '<cmd>NvimTreeToggle<cr>', desc = 'NvimTree'},
        },
        config = true,
    },
    -- filetypes
    'alker0/chezmoi.vim',
    { 'plasticboy/vim-markdown', ft = 'md' },
    { 'chrisbra/csv.vim', ft = {'csv', 'tsv'} },
    { 'kaarmu/typst.vim', ft = 'typst' },
    -- completion/lsp/lint
    {
        'mfussenegger/nvim-lint',
        ft = 'srcpkg',
        config = require('cfg.lint'),
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = 'hrsh7th/cmp-nvim-lsp',
        config = require('cfg.lspconfig'),
    },
    {
        'petertriho/cmp-git',
        dependencies = 'nvim-lua/plenary.nvim',
        config = true,
    },
    {
        'dcampos/cmp-snippy',
        dependencies = {
            'dcampos/nvim-snippy',
            config = {
                mappings = {
                    is = {
                        ['<Tab>'] = 'expand_or_advance',
                        ['<S-Tab>'] = 'previous',
                    },
                    nx = { ['<leader>x'] = 'cut_text', },
                },
            },
        },
    },
    {
        'hrsh7th/nvim-cmp',
        config = require('cfg.cmp'),
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'petertriho/cmp-git',
            'dcampos/cmp-snippy',
        },
    },
    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        -- TODO: https://github.com/hiphish/rainbow-delimiters.nvim
	    dependencies = 'HiPhish/nvim-ts-rainbow2',
        build = ':TSUpdate',
        config = require('cfg.treesitter'),
    },
}
