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

require("lazy").setup({
    "lewis6991/gitsigns.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
          -- Snippet Engine & its associated nvim-cmp source
          'L3MON4D3/LuaSnip',
          'saadparwaiz1/cmp_luasnip',

          -- Adds LSP completion capabilities
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-path',

          -- Adds a number of user-friendly snippets
          'rafamadriz/friendly-snippets',
        },
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    'folke/neodev.nvim'
})

require("gitsigns").setup()
require("nvim-treesitter").setup()
require('mason').setup()
require('mason-lspconfig').setup()
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

local directories_to_search = { 
        '.clangd',
        '.settings'}

local function findCCD(directories)
    for _, dir in ipairs(directories) do
        local full_path = dir .. "/compile_commands.json"
        if (vim.fn.filereadable(full_path)) then
            return dir
        end
    end
    return nil
end

local clangd_opts = {
  cmd = {
        "clangd",
  --        "--background-index",
        "--suggest-missing-includes",
        --"--compile-commands-dir=" .. findCCD(directories_to_search),
        "--compile-commands-dir=/home/ilyasha/workspaces/code-mkd/develop/mk4/.clangd/",
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  on_attach = on_attach,
}

nvim_lsp.clangd.setup(clangd_opts)

    

local builtin = require('telescope.builtin')
vim.keymap.set('n', '\\f', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
