return function()
    require('nvim-tree').setup({})

    vim.keymap.set('n', '<c-n>', function() require('nvim-tree.api').tree.toggle({ find_file = true }) end)
end
