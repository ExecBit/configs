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
            'nvim-treesitter/nvim-treesitter-context',
            config = C.treesitter_context
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
            config = C.telescope,
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
            config = C.gitsigns,
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
        },

        {
            'stevearc/oil.nvim',
            opts = {},
            dependencies = { "echasnovski/mini.icons" },
            config = C.oil
        },

        {
            "willothy/flatten.nvim",
            config = true,
            -- or pass configuration with
            -- opts = {  }
            -- Ensure that it runs first to minimize delay when opening file from terminal
            lazy = false,
            priority = 1001,
        },

        {
            'stevearc/overseer.nvim',
            config = C.overseer,
            cmd = {
                "OverseerOpen",
                "OverseerClose",
                "OverseerToggle",
                "OverseerSaveBundle",
                "OverseerLoadBundle",
                "OverseerDeleteBundle",
                "OverseerRunCmd",
                "OverseerRun",
                "OverseerInfo",
                "OverseerBuild",
                "OverseerQuickAction",
                "OverseerTaskAction",
                "OverseerClearCache",
            },
            opts = {
                dap = false,
                task_list = {
                    bindings = {
                      ["<C-h>"] = false,
                      ["<C-j>"] = false,
                      ["<C-k>"] = false,
                      ["<C-l>"] = false,
                    },
                },
                form = {
                    win_opts = {
                      winblend = 0,
                    },
                },
                confirm = {
                    win_opts = {
                      winblend = 0,
                    },
                },
                task_win = {
                    win_opts = {
                      winblend = 0,
                    },
                },
            },

            keys = {
                { "<leader>ow", "<cmd>OverseerToggle<cr>",      desc = "Task list" },
                { "<leader>oo", "<cmd>OverseerRun<cr>",         desc = "Run task" },
                { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
                { "<leader>oi", "<cmd>OverseerInfo<cr>",        desc = "Overseer Info" },
                { "<leader>ob", "<cmd>OverseerBuild<cr>",       desc = "Task builder" },
                { "<leader>ot", "<cmd>OverseerTaskAction<cr>",  desc = "Task action" },
                { "<leader>oc", "<cmd>OverseerClearCache<cr>",  desc = "Clear cache" },
            },
        },

    })

vim.cmd.colorscheme "catppuccin-macchiato"

