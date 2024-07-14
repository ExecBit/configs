vim.api.nvim_set_keymap('n', ']b', 'gt', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '[b', 'gT', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-[>', '<C-\\><C-n>', {noremap = true})

vim.g.mapleader = ' '
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.opt.scrolloff = 999 - vim.o.scrolloff
