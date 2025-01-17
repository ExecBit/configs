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

-- Automatically save the neovim session before exiting
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
        local session_file = string.format("~/.config/nvim/session_%s.vim", timestamp)
        vim.cmd("mksession! " .. session_file)
    end,
})

-- Включить отображение невидимых символов
vim.opt.list = true

-- Настроить символы для отображения пробелов и табов
vim.opt.listchars = {
  eol = '$',     -- Символ для отображения конца строки
  space = '·',   -- Символ для отображения пробелов
  tab = '>-',    -- Символ для отображения табов
  trail = '~',   -- Символ для отображения пробелов в конце строки
  extends = '#', -- Символ для отображения продолжения строки
  precedes = '#', -- Символ для отображения начала строки
  nbsp = '%',    -- Символ для отображения неразрывных пробелов
}

