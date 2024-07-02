local setup = function()
    require('lspconfig').pyright.setup {}
end

local ft = {
    '*.py'
}

local M = {
    ft = ft,
    setup = setup,
}

return M


