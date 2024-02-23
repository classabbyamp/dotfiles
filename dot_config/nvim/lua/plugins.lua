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
    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = true,
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = 'nvim-tree/nvim-web-devicons',
        lazy = false,
        config = require('cfg.tree'),
    },
    -- filetypes
    'alker0/chezmoi.vim',
    {
        'cameron-wags/rainbow_csv.nvim',
        ft = { 'csv', 'tsv', 'csv_semicolon', 'csv_whitespace', 'csv_pipe', 'rfc_csv', 'rfc_semicolon', },
        cmd = { 'RainbowDelim', 'RainbowDelimSimple', 'RainbowDelimQuoted', 'RainbowMultiDelim' },
        config = true,
    },
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
        build = ':TSUpdate',
        config = require('cfg.treesitter'),
    },
    {
        'hiphish/rainbow-delimiters.nvim',
        config = function()
            require('rainbow-delimiters.setup').setup({
                strategy = { [''] = require('rainbow-delimiters').strategy['global'], },
                query = { [''] = 'rainbow-delimiters', },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            })
        end,
    },
}
