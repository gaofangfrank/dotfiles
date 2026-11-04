local map = vim.keymap.set

-- Preserve indentation on newline
map('i', '<CR>', '<CR>x<BS>', { noremap = true })
map('i', '{<CR>', '{}<Left><CR><Up><End><CR>x<BS>', { noremap = true })

-- Search for visually selected text with //
map('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { noremap = true })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { noremap = true })
map('n', '<C-j>', '<C-w><C-j>', { noremap = true })
map('n', '<C-k>', '<C-w><C-k>', { noremap = true })
map('n', '<C-l>', '<C-w><C-l>', { noremap = true })

-- Native clang-format integration (no pynvim required)
local clang_format_bin = '/home/f00632390/.local/llvm/bin/clang-format'
if vim.fn.executable(clang_format_bin) == 0 then
  clang_format_bin = 'clang-format'
end

local function run_clang_format(start_line, end_line)
  if vim.fn.executable(clang_format_bin) == 0 then
    vim.notify('clang-format executable not found', vim.log.levels.ERROR)
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local view = vim.fn.winsaveview()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = table.concat(lines, '\n') .. '\n'

  local cmd = { clang_format_bin, '-style=file', '-fallback-style=LLVM' }
  if filename ~= '' then
    table.insert(cmd, '--assume-filename=' .. filename)
  end
  if start_line and end_line then
    table.insert(cmd, string.format('-lines=%d:%d', start_line, end_line))
  end

  local res = vim.system(cmd, { stdin = input, text = true }):wait()
  if res.code ~= 0 then
    vim.notify('clang-format error: ' .. (res.stderr or ''), vim.log.levels.ERROR)
    return
  end

  local formatted = vim.split(res.stdout or '', '\n', { plain = true })
  if formatted[#formatted] == '' then
    table.remove(formatted, #formatted)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
  vim.fn.winrestview(view)
end

-- <C-I>: format current line (normal/insert) or selection (visual)
map('n', '<C-I>', function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  run_clang_format(lnum, lnum)
end, { desc = 'Clang-format current line' })

map('x', '<C-I>', function()
  local s = vim.fn.line('v')
  local e = vim.fn.line('.')
  if s > e then s, e = e, s end
  run_clang_format(s, e)
end, { desc = 'Clang-format visual selection' })

map('i', '<C-I>', function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  run_clang_format(lnum, lnum)
end, { desc = 'Clang-format current line in insert mode' })

-- <C-P> and :call FormatFile() compatibility: format entire buffer
_G.FormatFile = function()
  run_clang_format(nil, nil)
end
vim.cmd([[
  function! FormatFile()
    lua _G.FormatFile()
  endfunction
]])
map({ 'n', 'x' }, '<C-P>', function()
  run_clang_format(nil, nil)
end, { desc = 'Clang-format entire file' })

-- JSON formatting command
vim.api.nvim_create_user_command('JSON', '%!python3 -m json.tool', {})
