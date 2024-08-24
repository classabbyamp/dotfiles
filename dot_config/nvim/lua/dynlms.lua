-- makes listchars.leadmultispace match the buffer's shiftwidth

local function update(listchars, newlen)
    -- cursed
    local lms = listchars.leadmultispace:match('^.?[\128-\191]*') or ' '
    listchars.leadmultispace = lms .. (' '):rep(newlen > 0 and newlen - 1 or 0)
    return listchars
end

local group = vim.api.nvim_create_augroup('DynamicLeadMultiSpace', {})

vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'shiftwidth',
    group = group,
    callback = function()
        if vim.v.option_type ~= 'local' then
            vim.opt.listchars = update(vim.opt.listchars:get(), vim.o.shiftwidth)
        else
            vim.opt_local.listchars = update(vim.opt_local.listchars:get(), vim.bo.shiftwidth)
        end
    end,
})

vim.api.nvim_create_autocmd({'BufWinEnter', 'FileType'}, {
    group = group,
    callback = function()
        vim.opt_local.listchars = update(vim.opt_local.listchars:get(), vim.bo.shiftwidth)
    end,
})
