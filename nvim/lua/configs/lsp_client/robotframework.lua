local setup = function()
    require('lspconfig').robotframework_ls.setup {}
end

local ft = {
    '*.robot',
}

local M = {
    ft = ft,
    setup = setup,
}

return M


