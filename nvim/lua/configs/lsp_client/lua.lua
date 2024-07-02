local setup = function()
    local settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            diagnostics = {
                -- Get the language server to recognize the 'vim', 'use' global
                globals = { 'vim', 'use' },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    }

    require('lspconfig').lua_ls.setup {
        settings = settings
    }
end

local ft = {
    '*.lua'
}

local M = {
    ft = ft,
    setup = setup,
}

return M
