local ok, codecompanion = pcall(require, 'codecompanion')
if not ok then
  return
end

local agy_bin = '/home/f00632390/.local/bin/agy'
if vim.fn.executable(agy_bin) == 0 then
  agy_bin = 'agy'
end

codecompanion.setup({
  adapters = {
    acp = {
      agy = function()
        return require('codecompanion.adapters').extend('gemini_cli', {
          name = 'agy',
          formatted_name = 'Antigravity (agy)',
          commands = {
            default = { agy_bin, 'acp' },
          },
          handlers = {
            lifecycle = {
              -- agy acp uses stored CLI credentials directly in session/new;
              -- returning true skips sending a redundant `authenticate` RPC
              -- that would otherwise trigger an interactive browser login.
              auth = function()
                return true
              end,
            },
          },
        })
      end,
    },
  },
  interactions = {
    chat = {
      adapter = 'agy',
    },
    inline = {
      adapter = 'agy',
    },
    cmd = {
      adapter = 'agy',
    },
  },
})

-- Logical, non-conflicting keybindings under <leader>a (Agent / Antigravity)
local map = vim.keymap.set
map({ 'n', 'x' }, '<leader>ac', '<Cmd>CodeCompanionChat Toggle<CR>', { silent = true, desc = 'AGY: Toggle Chat' })
map({ 'n', 'x' }, '<leader>an', '<Cmd>CodeCompanionChat<CR>', { silent = true, desc = 'AGY: New Chat' })
map({ 'n', 'x' }, '<leader>aa', '<Cmd>CodeCompanionActions<CR>', { silent = true, desc = 'AGY: Action Palette' })
map('x', '<leader>ad', '<Cmd>CodeCompanionChat Add<CR>', { silent = true, desc = 'AGY: Add selection to Chat' })
map({ 'n', 'x' }, '<leader>ai', ':CodeCompanion ', { desc = 'AGY: Inline prompt' })
