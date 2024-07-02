local setup = function()
    require('nvim-treesitter.configs').setup {
        ensure_installed = {
            'cpp',
            'rust',
            'toml',
            'lua',
            'regex',
            'vim',
            'bash',
            'markdown',
            'markdown_inline'
        },
        highlight = {
            enable = true
        },
        autotag = {
            enable = true
        },
        matchup = {
            enable = true
        }
    }

    vim.cmd(':TSUpdate')
end

local M = {
    setup = setup,
}

return M
