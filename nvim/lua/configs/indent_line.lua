local setup = function()
    require('indent-blankline').setup{
        main = 'ibl',
        opts = {},
    }
end

local M = {
    setup = setup,
}

return M

