local C = require('configs')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local is_git_folder = os.execute('git rev-parse --is-inside-work-tree') == 0
local mason_lazy = C.mason_lazy()

require('lazy').setup({
        {
            'EdenEast/nightfox.nvim',
            priority = 1000,
            config = C.nightfox
        },

        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000
        },

        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = C.lualine
        },

        {
            'nvim-treesitter/nvim-treesitter',
            config = C.treesitter
        },

        {
            'williamboman/mason.nvim',
            lazy = true,
            event = mason_lazy,
            dependencies = {
                'williamboman/mason-lspconfig.nvim',
                'neovim/nvim-lspconfig',
                'ray-x/lsp_signature.nvim'
            },
            config = C.mason
        },

        {
            'MysticalDevil/inlay-hints.nvim',
            lazy = true,
            event = "LspAttach",
            config = true,
        },

        {
            'mrcjkb/rustaceanvim',
            lazy = false, -- already lazy
            version = '^4',
        },

        {
            'saecki/crates.nvim',
            lazy = true,
            event = 'BufRead Cargo.toml',
            dependencies = { 'nvim-lua/plenary.nvim' },
            config = C.crates,
        },

        {
            'glepnir/lspsaga.nvim',
            lazy = true,
            event = mason_lazy,
            config = C.lspsaga
        },

        {
            'L3MON4D3/LuaSnip',
            lazy = true,
            tag = "v2.3.0",
            build = "make install_jsregexp",
            config = C.luasnip
        },

        {
            'hrsh7th/nvim-cmp',
            lazy = true,
            event = 'InsertEnter',
            dependencies = {
                'saadparwaiz1/cmp_luasnip',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-nvim-lsp',
                'onsails/lspkind-nvim',
            },
            config = C.cmp,
        },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
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
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      vim.g.mapleader = ' '
      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })


          local map = function(keys, func)
            vim.keymap.set('n', keys, func)
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions)

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references)
          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations)

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions)

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols)

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename)

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action)

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover)

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration)

    end,
  },

        {
            'stevearc/oil.nvim',
            priority = 999,
            config = C.oil,
        },

        {
            'numToStr/Comment.nvim',
            lazy = true,
            event = mason_lazy,
            config = true
        },

        {
            'lewis6991/gitsigns.nvim',
            cond = is_git_folder,
            config = true,
        },

        {
            'tpope/vim-fugitive',
            cond = is_git_folder,
        },

        {
            'alvarosevilla95/luatab.nvim',
            lazy = true,
            config = C.luatab
        },

        {
            'folke/noice.nvim',
            dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
            config = C.noice
        },

        {
            'folke/neodev.nvim',
            lazy = true,
            event = 'BufReadPre *.lua',
            config = true
        },

        {
            'folke/flash.nvim',
            event = 'VeryLazy',
            config = C.flash
        },

        {
            'nvim-pack/nvim-spectre',
            config = true
        },

        {
            'folke/tokyonight.nvim',
            priority = 1000,
            config = C.tokyonight
        }
    })

vim.cmd.colorscheme "catppuccin-macchiato"

