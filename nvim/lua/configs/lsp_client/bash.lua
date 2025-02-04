local setup = function()
    require('lspconfig').bashls.setup {}
end

local ft = {
    '*.bash',
    '*.sh',
}

local M = {
    ft = ft,
    setup = setup,
}

return M


