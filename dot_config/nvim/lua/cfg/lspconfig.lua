return function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- xi rust-analyzer
    require('lspconfig').rust_analyzer.setup {
        capabilities = capabilities
    }

    -- xi pyright
    require('lspconfig').pyright.setup {
        capabilities = capabilities
    }

    -- xi bash-language-server
    require('lspconfig').bashls.setup {
        capabilities = capabilities,
        filetypes = { "sh", "bash" },
        on_attach = function(client)
            local path = vim.fn.expand('%:p')
            if path:find('^' .. vim.fn.expand('~/void') .. '/packages/srcpkgs') ~= nil then
                client.config.settings.bashIde.shellcheckArguments = {'-e', 'SC2034', '-e', 'SC2148', '-e', 'SC2317'}
            else
                client.config.settings.bashIde.shellcheckArguments = {}
            end
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            return true
        end,
        settings = { bashIde = { shellcheckArguments = {} } },
    }

    local function dirname(path)
        local strip_dir_pat = '/([^/]+)$'
        local strip_sep_pat = '/$'
        if not path or #path == 0 then
            return
        end
        local result = path:gsub(strip_sep_pat, ''):gsub(strip_dir_pat, '')
        if #result == 0 then
            if vim.loop.os_uname().version:match 'Windows' then
                return path:sub(1, 2):upper()
            else
                return '/'
            end
        end
        return result
    end

    -- xi typst-lsp
    require('lspconfig').typst_lsp.setup {
        capabilities = capabilities,
        settings = {
            exportPdf = "onSave",
        },
        root_dir = function(fname)
            return require('lspconfig.util').find_git_ancestor(fname) or dirname(fname)
        end
    }

    -- xi lua-language-server
    require('lspconfig').lua_ls.setup {
        settings = {
            Lua = {
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim', 'awesome'},
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }
end
