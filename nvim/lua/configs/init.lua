local M = {}

M.treesitter = require('configs.treesitter').setup
M.mason = require('configs.mason').setup
M.mason_lazy = require('configs.mason').lazy_load
M.cmp = require('configs.cmp').setup
M.telescope = require('configs.telescope').setup
M.lualine = require('configs.lualine').setup
M.gitsigns = require('configs.gitsigns').setup
M.overseer = require('configs.overseer').setup

return M
