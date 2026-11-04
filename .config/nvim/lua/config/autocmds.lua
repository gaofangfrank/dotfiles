local augroup = vim.api.nvim_create_augroup('UserConfig', { clear = true })

-- Close Neovim if the last remaining window is NERDTree
vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup,
  callback = function()
    if vim.fn.winnr('$') == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree then
      vim.cmd('quit')
    end
  end,
})

-- Jump to last known cursor position when opening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup,
  callback = function(ev)
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if bufname:match('%.git[/\\]COMMIT_EDITMSG$') then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 1 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Termdebug built-in debugger configuration
vim.cmd('packadd! termdebug')
vim.g.termdebug_config = {
  wide = 110,
  timeout = 9001,
}
vim.keymap.set('n', '<leader>td', '<Cmd>Termdebug!<CR>', { desc = 'Launch Termdebug' })
