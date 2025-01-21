local keyMap = function(keys, func)
    vim.keymap.set('n', keys, func, { noremap = true, silent = true })
end

keyMap(']b', 'gt')
keyMap('[b', 'gT')
vim.keymap.set('t', '<C-[>', '<C-\\><C-n>', {noremap = true})

vim.g.mapleader = ' '
keyMap('[d', vim.diagnostic.goto_prev)
keyMap(']d', vim.diagnostic.goto_next)

--kill buffer without killing window
keyMap('<leader>q', function() vim.cmd('bp | sp | bn | bd') end)
--kill buffer and create new, without killing window
--keyMap('<leader>i', ':enew<bar>bd #<CR>')

vim.opt.scrolloff = 999 - vim.o.scrolloff

