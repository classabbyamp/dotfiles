return function()
    require('chezmoi').setup({ edit = { watch = true } })

    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = {
            vim.fn.expand('~') .. '/.local/share/chezmoi*/*',
        },
        callback = function()
            if vim.bo.filetype ~= 'gitcommit' then
                vim.schedule(require('chezmoi.commands.__edit').watch)
            end
        end,
    })
end
