return function()
    require('chezmoi').setup({ edit = { watch = true } })

    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { os.getenv('HOME') .. '/.local/share/chezmoi/*' },
        callback = function()
        vim.schedule(require('chezmoi.commands.__edit').watch)
        end,
    })
end
