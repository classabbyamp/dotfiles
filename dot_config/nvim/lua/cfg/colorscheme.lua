return function()
    vim.o.termguicolors = true

    require('catppuccin').setup {
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
            ts_rainbow2 = true,
        }
    }

    vim.cmd.colorscheme('catppuccin')
end
