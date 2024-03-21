return function()
    vim.o.termguicolors = true

    require('catppuccin').setup {
        flavour = 'mocha',
        transparent_background = true,
        integrations = {
            cmp = true,
            gitsigns = true,
            ts_rainbow2 = true,
        }
    }

    vim.cmd.colorscheme('catppuccin')
end
