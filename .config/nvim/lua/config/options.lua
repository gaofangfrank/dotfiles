local opt = vim.opt

opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.hlsearch = true
opt.wrap = false
opt.autoindent = true
opt.showmatch = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'
opt.tags = 'tags;'
opt.visualbell = false
opt.errorbells = false
opt.colorcolumn = '+1'
opt.splitbelow = true
opt.splitright = true
opt.backspace = { 'indent', 'eol', 'start' }
opt.completeopt = { 'menuone', 'noselect', 'popup' }

vim.g.python_highlight_all = 1
if vim.fn.executable('/home/f00632390/.local/conda/envs/triton/bin/python3') == 1 then
  vim.g.python3_host_prog = '/home/f00632390/.local/conda/envs/triton/bin/python3'
end
