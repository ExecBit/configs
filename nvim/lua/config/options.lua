--  vim.g.mapleader = ' '
--  vim.g.maplocalleader = ' '
--  vim.g.have_nerd_font = false
--  vim.opt.number = true
--  vim.opt.relativenumber = true
--  vim.opt.mouse = 'a'
--  vim.opt.showmode = false
--  vim.schedule(function() vim.opt.clipboard = 'unnamedplus' end)
--  vim.opt.breakindent = true
--  vim.opt.undofile = true
--  vim.opt.ignorecase = true
--  vim.opt.smartcase = true
--  vim.opt.signcolumn = 'yes'
--  vim.opt.updatetime = 250
--  vim.opt.timeoutlen = 300
--  vim.opt.splitright = true
--  vim.opt.splitbelow = true
--  vim.opt.list = false
--  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
--  vim.opt.inccommand = 'split'
--  vim.opt.cursorline = true
--  vim.opt.scrolloff = 10
--  vim.opt.winborder = "solid" -- https://neovim.io/doc/user/options.html#'winborder'



vim.o.number = true
vim.o.termguicolors = true

-- Set highlight on search
vim.o.hlsearch = true

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.scrolloff = 8

--Tabs options
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smartindent = true

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.shell = "/bin/fish"

-- Включить отображение невидимых символов
vim.opt.list = true

-- Настроить символы для отображения пробелов и табов
vim.opt.listchars = {
--  eol = '⤶',     -- Символ для отображения конца строки
  space = '·',   -- Символ для отображения пробелов
  tab = '>-',    -- Символ для отображения табов
  trail = '~',   -- Символ для отображения пробелов в конце строки
  extends = '#', -- Символ для отображения продолжения строки
  precedes = '#', -- Символ для отображения начала строки
  nbsp = '%',    -- Символ для отображения неразрывных пробелов
}

vim.opt.encoding = 'utf-8'
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.autoread = true
vim.opt.ttyfast = true
