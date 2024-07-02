local setup = function()
    require('lspconfig').clangd.setup {}
    vim.keymap.set('n', '<space>t', ':ClangdSwitchSourceHeader<CR>')
end

local ft = {
    '*.cpp',
    '*.c',
    '*.h',
    '*.hpp'
}

local M = {
    ft = ft,
    setup = setup,
}

return M


