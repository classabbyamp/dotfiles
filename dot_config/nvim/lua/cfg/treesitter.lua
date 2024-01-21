return function()
    require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        ignore_install = {},
        auto_install = false,
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
    }
end
