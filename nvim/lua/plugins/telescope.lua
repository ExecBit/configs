return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
            'nvim-telescope/telescope-fzf-native.nvim',

            -- `build` is used to run some command when the plugin is installed/updated.
            -- This is only run then, not every time Neovim starts up.
            build = 'make',

            -- `cond` is a condition used to determine whether this plugin should be
            -- installed and loaded.
            cond = function()
              return vim.fn.executable 'make' == 1
            end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
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

        -- enable telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local telescopemap = function(keys, func)
            vim.keymap.set('n', keys, func, { noremap = true, silent = true })
        end

        local builtin = require('telescope.builtin')
        telescopemap('<leader>sh', builtin.help_tags)
        telescopemap('<leader>sk', builtin.keymaps)
        telescopemap('<leader>sf', builtin.find_files)
        telescopemap('<leader>ss', builtin.builtin)
        telescopemap('<leader>sw', builtin.grep_string)
        telescopemap('<leader>sg', builtin.live_grep)
        telescopemap('<leader>sd', builtin.diagnostics)
        telescopemap('<leader>sr', builtin.resume)
        telescopemap('<leader>s.', builtin.oldfiles)
        telescopemap('<leader><leader>', builtin.buffers)
        -- shortcut for searching your neovim configuration files
        telescopemap('<leader>sn', function() builtin.find_files({ cwd = vim.fn.stdpath 'config'}) end)

        local map = function(keys, func)
          vim.keymap.set('n', keys, func)
        end

        map('gd', builtin.lsp_definitions)
        map('gr', builtin.lsp_references)
        map('gi', builtin.lsp_implementations)
        map('<leader>d', builtin.lsp_type_definitions)
        map('<leader>ds', builtin.lsp_document_symbols)
        map('<leader>ws', builtin.lsp_dynamic_workspace_symbols)
        map('<leader>rn', vim.lsp.buf.rename)
        map('<leader>ca', vim.lsp.buf.code_action)
        map('K', vim.lsp.buf.hover)
        map('gd', vim.lsp.buf.declaration)
    end,
}
