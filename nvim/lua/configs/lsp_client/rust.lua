local setup = function()
    local settings = {
        ['rust-analyzer'] = {
            assist = {
                importGranularity = 'module',
                importPrefix = 'by_self'
            },
            inlayHints = {
                parameterHints = false,
            },
            checkOnSave = {
                command = 'clippy'
            },
            cargo = {
                allFeatures = true,
            },
            rustfmt = {
                extraArgs = { "+nightly" }
            },
        }
    }

    vim.g.rustaceanvim = {
        server = {
            on_attach = function(_, _)
                vim.api.nvim_command [[
                    autocmd BufWritePre *.rs lua vim.lsp.buf.format()
                ]]
            end,
            default_settings = settings,
        }
    }
end

local ft = {
    '*.rs'
}

local M = {
    ft = ft,
    setup = setup,
}

return M
