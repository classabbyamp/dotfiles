return function()
    local lint = require('lint')

    lint.linters_by_ft = {
        srcpkg = { 'xlint', }
    }

    lint.linters.xlint = {
        cmd = 'xlint',
        stdin = false,
        ignore_exitcode = true,
        parser = require('lint.parser').from_pattern(
            -- '([^:]+):([^:]+):([0-9]+): (.+)',
            -- { 'file', 'severity', 'lnum', 'message' },
            '([^:]+):([0-9]+): (.+)',
            { 'file', 'lnum', 'message' },
            {
                error = vim.diagnostic.severity.ERROR,
                warning = vim.diagnostic.severity.WARN,
            },
            {
                lnum = 1,
                col = 1,
            }
        ),
    }

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
        callback = function()
            require('lint').try_lint()
        end,
    })
end
