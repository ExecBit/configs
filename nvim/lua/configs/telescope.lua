local keys = function()
    local keys = {
        { '<leader>f', '<cmd>lua require("telescope.builtin").find_files()<CR>' },
        { '<leader>s', '<cmd>lua require("telescope.builtin").live_grep()<CR>' },
        { '<leader>1', '<cmd>lua require("telescope.builtin").grep_string()<CR>' },
        { '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<CR>' },
        { '<leader>d', '<cmd>lua require("telescope.builtin").diagnostics()<CR>' },
        { 'gd',        '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>' },
        { 'gi',        '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>' },
    }

    return keys
end

local M = {
    keys = keys,
}

return M
