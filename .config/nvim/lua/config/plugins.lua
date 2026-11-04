-- Plugin globals (must be set before loading plugins)
vim.g.rigel_airline = 1
vim.g.airline_theme = 'rigel'

-- Taglist settings
vim.g.Tlist_Use_Right_Window = 1
vim.g.Tlist_Exit_OnlyWindow = 1

-- NERDCommenter settings
vim.g.NERDCommentWholeLinesInVMode = 1
vim.g.NERDSpaceDelims = 1
vim.g.NERDTrimTrailingWhitespace = 1

-- Hexmode settings
vim.g.hexmode_xxd_options = '-g 1'

-- Manage plugins via Neovim 0.12 built-in vim.pack
vim.pack.add({
  'https://github.com/Rigellute/rigel.git',
  'https://github.com/NLKNguyen/papercolor-theme.git',
  'https://github.com/vim-airline/vim-airline.git',
  'https://github.com/vim-airline/vim-airline-themes.git',
  'https://github.com/scrooloose/nerdtree.git',
  'https://github.com/scrooloose/nerdcommenter.git',
  'https://github.com/nvim-lua/plenary.nvim.git',
  'https://github.com/olimorris/codecompanion.nvim.git',
  'https://github.com/bfrg/vim-cpp-modern.git',
  'https://github.com/tpope/vim-fugitive.git',
  'https://github.com/Konfekt/FastFold.git',
  'https://github.com/chrisbra/csv.vim.git',
  'https://github.com/fidian/hexmode.git',
  'https://github.com/azabiong/vim-highlighter.git',
  'https://github.com/MTDL9/vim-log-highlighting.git',
  'https://github.com/yegappan/taglist.git',
}, { load = true, confirm = false })

-- Apply colorscheme after loading theme plugins
vim.o.background = 'dark'
vim.cmd.colorscheme('rigel')

-- Plugin keymaps
vim.keymap.set('n', 'tn', '<Cmd>NERDTreeToggle<CR>', { silent = true, desc = 'Toggle NERDTree' })
vim.keymap.set('n', '<leader>f', '<Cmd>TlistToggle<CR>', { silent = true, desc = 'Toggle Taglist' })
