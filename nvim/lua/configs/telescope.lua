local setup = function()
      require('telescope').setup {
        defaults = {
                layout_strategy = "vertical",
                layout_config = {
                  vertical = {
                    preview_cutoff = 0,
                    prompt_position = "top",
                    width = { padding = 0 },
                    height = { padding = 0 },
                    preview_width = 0.5,
                  },
                },
                sorting_strategy = "ascending",
        },
        pickers = {
            lsp_references = {
                show_line = false
            },
            lsp_definitions = {
                show_line = false
            },
            buffers = {
                sort_mru = true,
                mappings = {
                    n = {
                        ["<c-d>"] = "delete_buffer",
                    },
                },
            }
        }
      }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local telescopeMap = function(keys, func)
        vim.keymap.set('n', keys, func, { noremap = true, silent = true })
    end

    local builtin = require('telescope.builtin')
    telescopeMap('<leader>sh', builtin.help_tags)
    telescopeMap('<leader>sk', builtin.keymaps)
    telescopeMap('<leader>sf', builtin.find_files)
    telescopeMap('<leader>ss', builtin.builtin)
    telescopeMap('<leader>sw', builtin.grep_string)
    telescopeMap('<leader>sg', builtin.live_grep)
    telescopeMap('<leader>sd', builtin.diagnostics)
    telescopeMap('<leader>sr', builtin.resume)
    telescopeMap('<leader>s.', builtin.oldfiles)
    telescopeMap('<leader><leader>', builtin.buffers)
    -- Shortcut for searching your Neovim configuration files
    telescopeMap('<leader>sn', function() builtin.find_files({ cwd = vim.fn.stdpath 'config'}) end)

    local map = function(keys, func)
      vim.keymap.set('n', keys, func)
    end

    map('gd', builtin.lsp_definitions)
    map('gr', builtin.lsp_references)
    map('gI', builtin.lsp_implementations)
    map('<leader>D', builtin.lsp_type_definitions)
    map('<leader>ds', builtin.lsp_document_symbols)
    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols)
    map('<leader>rn', vim.lsp.buf.rename)
    map('<leader>ca', vim.lsp.buf.code_action)
    map('K', vim.lsp.buf.hover)
    map('gD', vim.lsp.buf.declaration)
end

local M = {
    setup = setup,
}

return M
