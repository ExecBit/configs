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

vim.keymap.set("t", "<C-A>", function()
    vim.api.nvim_feedkeys("pwd | wl-copy\n", "t", false) -- Копируем путь
    vim.api.nvim_input("<C-\\><C-n>")
    vim.defer_fn(function()
        vim.cmd('cd ' .. vim.fn.getreg('+')) -- Ждём обновления clipboard и только потом выполняем cd
    end, 50) -- 50 мс задержки

end, { silent = true })

