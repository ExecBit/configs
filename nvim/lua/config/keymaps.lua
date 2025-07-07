vim.keymap.set('n', '<space>t', ':LspClangdSwitchSourceHeader<CR>')

local keyNormalMap = function(keys, func)
    vim.keymap.set('n', keys, func, { noremap = true, silent = true })
end

local keyTermMap = function(keys, func)
    vim.keymap.set('t', keys, func, { noremap = true, silent = true })
end

keyNormalMap(']b', 'gt')
keyNormalMap('[b', 'gT')

vim.g.mapleader = ' '
keyNormalMap('[d', vim.diagnostic.goto_prev)
keyNormalMap(']d', vim.diagnostic.goto_next)

keyTermMap('<C-[>', '<C-\\><C-n>')

vim.opt.scrolloff = 999 - vim.o.scrolloff


vim.api.nvim_create_user_command('GrepCurrent', function(opts)
  local pattern = opts.args
  if not pattern or pattern == '' then
    print('Usage: GrepCurrent <pattern>')
    return
  end

  -- 1. Получаем строки текущего файла
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- 2. Формируем QuickFix-записи (без filename, lnum и других полей)
  local qf_entries = {}
  for line_num, line in ipairs(lines) do
    if line:find(pattern) then
      -- Добавляем только текст строки (без привязки к файлу)
      table.insert(qf_entries, {
        --text = line:gsub('^%s+', ''):gsub('%s+$', ''),  -- Обрезаем пробелы
        text = string.format('[%d] %s', line_num, line),  -- "Line 42 → текст"
        valid = true,  -- Помечаем как "валидную" запись (иначе QuickFix может ругаться)
      })
    end
  end

  -- 3. Загружаем в QuickFix
  if #qf_entries > 0 then
    vim.fn.setqflist({}, 'r', { items = qf_entries, title = 'Matches: ' .. pattern })
    vim.cmd('copen | only')
  else
    print('No matches found for: ' .. pattern)
  end
end, { nargs = 1, desc = 'Search in current file, show ONLY matching lines' })

