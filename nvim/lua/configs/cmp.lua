local tab_mapping = function()
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local luasnip = require('luasnip')
    local cmp = require('cmp')

    return cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" })
end

local shift_tab_mapping = function()
    local luasnip = require('luasnip')
    local cmp = require('cmp')

    return cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable( -1) then
            luasnip.jump( -1)
        else
            fallback()
        end
    end, { "i", "s" })
end

local setup = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    vim.o.completeopt = 'menuone,noselect'

    local cmp = require 'cmp'
    cmp.setup {
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'crates' }
        },
        mapping = {
            ['<C-Space>'] = cmp.mapping.complete({}),
            ['<CR>'] = cmp.mapping.confirm(),
            ['<Tab>'] = tab_mapping(),
            ['<S-Tab>'] = shift_tab_mapping(),
            ['<C-e>'] = cmp.mapping.close()
        },
        formatting = {
            format = require('lspkind').cmp_format({ with_text = true, menu = ({
                buffer = '[Buffer]',
                nvim_lsp = '[LSP]',
                luasnip = '[LuaSnip]',
                path = '[Path]',
            }) }),
        },
        experimental = {
            ghost_text = true
        }
    }
end

local M = {
    setup = setup,
}

return M
