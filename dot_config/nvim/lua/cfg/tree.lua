return function()
    require('nvim-tree').setup({
        renderer = {
            highlight_git = "name",
            icons = {
                diagnostics_placement = "after",
                glyphs = {
                    git = {
                        unstaged = "~",
                        staged = "✓",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "?",
                        deleted = "",
                        ignored = "◌",
                    }
                }
            }
        },
    })

    vim.keymap.set('n', '<c-n>', function() require('nvim-tree.api').tree.toggle({ find_file = true }) end)
end
