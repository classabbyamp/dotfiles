return function()

    -- xi rust-analyzer
    vim.lsp.enable('rust_analyzer')
    -- xi pyright
    vim.lsp.enable('pyright')
    -- xi ruff
    vim.lsp.enable('ruff')
    -- xi qt6-declarative-tools
    vim.lsp.enable('qmlls')
    -- xi clang-tools-extra Bear
    vim.lsp.enable('clangd')
    -- xi gopls
    vim.lsp.enable('gopls')

    -- xi bash-language-server
    vim.lsp.enable('bashls')
    vim.lsp.config('bashls', {
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
    })

    -- xi tinymist
    vim.lsp.enable('tinymist')
    vim.lsp.config('tinymist', {
        settings = {
            formatterMode = "typstyle",
            exportPdf = "onDocumentHasTitle",
            rootPath = "-",
        }
    })

    -- xi lua-language-server
    vim.lsp.enable('lua_ls')
    vim.lsp.config('lua_ls', {
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
    })
end
