local M = {}

M.treesitter = require('configs.treesitter').setup
M.mason = require('configs.mason').setup
M.mason_lazy = require('configs.mason').lazy_load
M.cmp = require('configs.cmp').setup
M.telescope_keys = require('configs.telescope').keys

return M
