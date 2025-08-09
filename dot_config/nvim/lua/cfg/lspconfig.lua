return function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
    local lspcfg = require('lspconfig')

    -- xi rust-analyzer
    lspcfg.rust_analyzer.setup {
        capabilities = capabilities
    }

    -- xi pyright
    lspcfg.pyright.setup {
        capabilities = capabilities
    }

    -- xi ruff
    lspcfg.ruff.setup {
        capabilities = capabilities
    }

    -- xi qt6-declarative-tools
    lspcfg.qmlls.setup {
        capabilities = capabilities
    }

    -- xi bash-language-server
    lspcfg.bashls.setup {
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

    -- xi tinymist
    lspcfg.tinymist.setup {
        capabilities = capabilities,
        settings = {
            formatterMode = "typstyle",
            exportPdf = "onDocumentHasTitle",
            rootPath = "-",
        }
    }

    -- xi lua-language-server
    lspcfg.lua_ls.setup {
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

    -- xi clang-tools-extra Bear
    require('lspconfig').clangd.setup {
        capabilities = capabilities,
    }

    -- xi gopls
    require('lspconfig').gopls.setup {
        capabilities = capabilities,
    }
end
