local keyNormalMap = function(keys, func)
    vim.keymap.set('n', keys, func, { noremap = true, silent = true })
end

local keyTermMap = function(keys, func)
    vim.keymap.set('t', keys, func, { noremap = true, silent = true })
end

keyNormalMap(']b', 'gt')
keyNormalMap('[b', 'gT')

vim.g.mapleader = ' '
keyNormalMap('[d', vim.diagnostic.goto_prev)
keyNormalMap(']d', vim.diagnostic.goto_next)

keyTermMap('<C-[>', '<C-\\><C-n>')

vim.opt.scrolloff = 999 - vim.o.scrolloff

