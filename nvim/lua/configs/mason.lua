local lsp_client = require('configs.lsp_client')

local mason_servers = {
    'lua_ls',
    'rust_analyzer',
    'clangd',
    'pyright',
    'bashls',
    'robotframework_ls',
}

vim.diagnostic.config {

    underline = true,

    virtual_text = {
        prefix = "",
        severity = nil,
        source = "if_many",
        format = nil,
    },

    signs = true,
    severity_sort = true,
    update_in_insert = false,
}

local setup = function()
    require('lsp_signature').setup {
        max_width = 100,
    }

    require('mason').setup {}

    local mason = require('mason-lspconfig')

    mason.setup {
        ensure_installed = mason_servers
    }

    mason.setup_handlers {
        function(server_name)
            require('lspconfig')[server_name].setup {}
        end,

        ['lua_ls'] = lsp_client.lua.setup,
        ['rust_analyzer'] = lsp_client.rust.setup,
        ['clangd'] = lsp_client.clang.setup,
        ['bashls'] = lsp_client.bash.setup,
        ['robotframework_ls'] = lsp_client.robotframework.setup,
    }
    vim.keymap.set({ 'n' }, '<C-k>', function()
        require('lsp_signature').toggle_float_win()
    end, { silent = true, noremap = true, desc = 'toggle signature' })

    vim.keymap.set({ 'n' }, '<Leader>k', function()
        vim.lsp.buf.signature_help()
    end, { silent = true, noremap = true, desc = 'toggle signature' })

    vim.keymap.set('n', '<leader>z', vim.lsp.buf.format)
end

local lazy_load = function()
    local all_ft = {
        lsp_client.lua.ft,
        lsp_client.rust.ft,
        lsp_client.clang.ft,
        lsp_client.python.ft,
        lsp_client.bash.ft,
        lsp_client.robotframework.ft,
    }

    local result = {}

    for i = 1, #all_ft do
        for j = 1, #all_ft[i] do
            result[#result + 1] = 'BufReadPre ' .. all_ft[i][j]
        end
    end

    return result
end

local M = {
    setup = setup,
    lazy_load = lazy_load
}

return M
